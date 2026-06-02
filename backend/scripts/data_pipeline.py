"""
Egypt Crop Data Pipeline
=========================
End-to-end pipeline for building a multi-year, multi-feature dataset of Egypt's top-10 crops.

Steps:
1. Extract top-10 crops from CROPGRIDSv1.08 NetCDF maps.
2. Attach SoilGrids (0–5 cm) properties via Google Earth Engine (GEE).
3. Attach annual TerraClimate variables (2010–2022).
4. Add monthly Sentinel-2 indices + SAR backscatter (2017–2024).
5. Merge and compute derived agronomic features.

Required Local Files:
- CROPGRIDSv1.08_NC_maps/ folder containing NetCDF crop maps.
- Countries_2018.nc in the same folder.
"""

import os
import glob
import json
import time
import logging
from typing import Tuple, List, Optional

import ee
import numpy as np
import pandas as pd
import xarray as xr
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# =============================================================================
# CONFIGURATION
# =============================================================================

# Google Earth Engine project ID
GEE_PROJECT = os.getenv("GEE_PROJECT", "ee-yasseralsaed777")

# Country code for Egypt in CROPGRIDSv1.08
EGYPT_COUNTRY_CODE = 57

# Years to process
SENTINEL_YEARS = list(range(2017, 2025))   # Sentinel-2 available from 2017
TERRACLIMATE_YEARS = list(range(2010, 2023))

# All calendar months
MONTHS = list(range(1, 13))

# Input data folder
CROPGRIDS_FOLDER = os.getenv("CROPGRIDS_FOLDER", "./CROPGRIDSv1.08_NC_maps")
COUNTRIES_FILE = "Countries_2018.nc"

# Output settings
OUTPUT_DIR = "data_outputs"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# File names
OUTPUT_V1 = os.path.join(OUTPUT_DIR, "Egypt_TOP10_CROPGRIDS_1.0.csv")
OUTPUT_V2 = os.path.join(OUTPUT_DIR, "Egypt_TOP10_CROPGRIDS_2.0.csv")
OUTPUT_V3 = os.path.join(OUTPUT_DIR, "Egypt_TOP10_CROPGRIDS_3.0.csv")
OUTPUT_MULTIYEAR = os.path.join(OUTPUT_DIR, "Egypt_TOP10_CROPGRIDS_MultiYear.csv")
OUTPUT_INDICES = os.path.join(OUTPUT_DIR, "Egypt_TOP10_CROPGRIDS_Indices.csv")
OUTPUT_ENHANCED = os.path.join(OUTPUT_DIR, "Egypt_TOP10_CROPGRIDS_Enhanced.csv")
OUTPUT_BOOSTER = os.path.join(OUTPUT_DIR, "FarmTech_Booster.csv")

# SoilGrids settings
SOIL_SCALING = {
    "phh2o_0-5cm_mean": 10,
    "soc_0-5cm_mean": 100,
    "clay_0-5cm_mean": 10,
    "sand_0-5cm_mean": 10,
    "nitrogen_0-5cm_mean": 100,
    "cec_0-5cm_mean": 10,
    "bdod_0-5cm_mean": 100,
    "silt_0-5cm_mean": 10,
    "cfvo_0-5cm_mean": 100,
    "ocd_0-5cm_mean": 100,
}

SOIL_RENAME = {
    "phh2o_0-5cm_mean": "soil_ph",
    "soc_0-5cm_mean": "soil_soc",
    "clay_0-5cm_mean": "soil_clay",
    "sand_0-5cm_mean": "soil_sand",
    "nitrogen_0-5cm_mean": "soil_nitrogen",
    "cec_0-5cm_mean": "soil_cec",
    "bdod_0-5cm_mean": "soil_bd",
    "silt_0-5cm_mean": "soil_silt",
    "cfvo_0-5cm_mean": "soil_cfvo",
    "ocd_0-5cm_mean": "soil_ocd",
}

TERRACLIMATE_SCALING = {
    "temp_mean": 10,
    "vpd_mean": 10,
    "srad_mean": 10,
    "wind_mean": 10,
}

FERTILITY_WEIGHTS = {
    "soil_soc": 0.4,
    "soil_nitrogen": 0.3,
    "soil_cec": 0.3,
}

CLAY_THRESHOLD = 35
SAND_THRESHOLD = 60

# Setup logging
logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger(__name__)

# =============================================================================
# SHARED UTILITIES
# =============================================================================

def build_feature_collection(fields: pd.DataFrame) -> ee.FeatureCollection:
    features = [
        ee.Feature(
            ee.Geometry.Point([row["lon"], row["lat"]]),
            {"Field_ID": row["Field_ID"]},
        )
        for _, row in fields.iterrows()
    ]
    return ee.FeatureCollection(features)

def sample_image(image: ee.Image, fc: ee.FeatureCollection, scale: int) -> pd.DataFrame:
    samples = image.sampleRegions(collection=fc, scale=scale, geometries=False)
    features = samples.getInfo()["features"]
    return pd.DataFrame([f["properties"] for f in features])

def _month_date_range(year: int, month: int) -> Tuple[str, str]:
    start = f"{year}-{month:02d}-01"
    end = f"{year + 1}-01-01" if month == 12 else f"{year}-{month + 1:02d}-01"
    return start, end

def classify_soil_texture(row: pd.Series) -> str:
    if row["soil_clay"] > CLAY_THRESHOLD:
        return "Clay"
    if row["soil_sand"] > SAND_THRESHOLD:
        return "Sandy"
    return "Loam"

def add_agronomic_features(df: pd.DataFrame) -> pd.DataFrame:
    df["precip_sum"] = df["precip_sum"].clip(lower=0.1)
    df["aet_mean"] = df["aet_mean"].clip(lower=0.1)
    if "soil_moisture" in df.columns:
        df["soil_moisture"] = df["soil_moisture"].clip(lower=0.1)

    df["soil_texture_class"] = df.apply(classify_soil_texture, axis=1)
    df["fertility_index"] = sum(df[col] * weight for col, weight in FERTILITY_WEIGHTS.items())

    if "pet_mean" in df.columns:
        df["aridity_index"] = df["precip_sum"] / df["pet_mean"].replace(0, 0.1)

    df["water_balance"] = df["precip_sum"] - df["aet_mean"]
    return df

# =============================================================================
# PIPELINE STEPS
# =============================================================================

def step1_extract_crops():
    logger.info("--- Step 1: Extracting Top Crops ---")
    if not os.path.exists(os.path.join(CROPGRIDS_FOLDER, COUNTRIES_FILE)):
        logger.error(f"Countries file not found in {CROPGRIDS_FOLDER}")
        return

    countries_ds = xr.open_dataset(os.path.join(CROPGRIDS_FOLDER, COUNTRIES_FILE))
    egypt_mask = countries_ds["country"] == EGYPT_COUNTRY_CODE

    records = []
    for file_path in glob.glob(os.path.join(CROPGRIDS_FOLDER, "*.nc")):
        filename = os.path.basename(file_path)
        if filename == COUNTRIES_FILE: continue
        ds = xr.open_dataset(file_path)
        total_area = float(ds["harvarea"].where(egypt_mask).sum().values)
        crop_name = filename.replace("CROPGRIDSv1.08_", "").replace(".nc", "")
        records.append({"Crop": crop_name, "Egypt_HarvestedArea": total_area})

    summary_df = pd.DataFrame(records).sort_values("Egypt_HarvestedArea", ascending=False).head(10)
    logger.info("Top 10 crops in Egypt:")
    logger.info(summary_df.to_string(index=False))

    dfs = []
    for crop in summary_df["Crop"]:
        file_path = os.path.join(CROPGRIDS_FOLDER, f"CROPGRIDSv1.08_{crop}.nc")
        ds = xr.open_dataset(file_path)
        df_crop = ds["harvarea"].where(egypt_mask).to_dataframe().reset_index().dropna(subset=["harvarea"])
        df_crop["Crop"] = crop
        dfs.append(df_crop)

    raw_df = pd.concat(dfs, ignore_index=True)
    raw_df.to_csv(OUTPUT_V1, index=False)

    field_df = raw_df[raw_df["harvarea"] > 0].copy()
    field_df["Field_ID"] = "F_" + field_df["lat"].round(3).astype(str) + "_" + field_df["lon"].round(3).astype(str)
    field_df["Year"] = 2015
    field_df = field_df[["Field_ID", "lat", "lon", "Crop", "harvarea", "Year"]]
    field_df.to_csv(OUTPUT_V2, index=False)
    logger.info(f"Step 1 complete. Saved {len(field_df)} rows to {OUTPUT_V2}")

def step2_soilgrids():
    logger.info("--- Step 2: Attaching SoilGrids ---")
    ee.Initialize(project=GEE_PROJECT)
    df_v2 = pd.read_csv(OUTPUT_V2)
    fields = df_v2[["Field_ID", "lat", "lon"]].drop_duplicates().reset_index(drop=True)
    fc = build_feature_collection(fields)

    soil_layers = {
        "projects/soilgrids-isric/phh2o_mean": "phh2o_0-5cm_mean",
        "projects/soilgrids-isric/soc_mean": "soc_0-5cm_mean",
        "projects/soilgrids-isric/clay_mean": "clay_0-5cm_mean",
        "projects/soilgrids-isric/sand_mean": "sand_0-5cm_mean",
        "projects/soilgrids-isric/nitrogen_mean": "nitrogen_0-5cm_mean",
        "projects/soilgrids-isric/cec_mean": "cec_0-5cm_mean",
        "projects/soilgrids-isric/bdod_mean": "bdod_0-5cm_mean",
        "projects/soilgrids-isric/silt_mean": "silt_0-5cm_mean",
        "projects/soilgrids-isric/cfvo_mean": "cfvo_0-5cm_mean",
        "projects/soilgrids-isric/ocd_mean": "ocd_0-5cm_mean",
    }

    bands = [ee.Image(asset).select(band) for asset, band in soil_layers.items()]
    soil_stack = bands[0]
    for band in bands[1:]: soil_stack = soil_stack.addBands(band)

    soil_df = sample_image(soil_stack, fc, scale=250)
    for raw_col, divisor in SOIL_SCALING.items():
        if raw_col in soil_df.columns:
            soil_df[raw_col] = soil_df[raw_col] / divisor
    soil_df = soil_df.rename(columns=SOIL_RENAME)

    df_v3 = df_v2.merge(soil_df, on="Field_ID", how="left")
    df_v3.to_csv(OUTPUT_V3, index=False)
    logger.info(f"Step 2 complete. Saved to {OUTPUT_V3}")

def step3_terraclimate():
    logger.info("--- Step 3: Attaching TerraClimate ---")
    ee.Initialize(project=GEE_PROJECT)
    df_base = pd.read_csv(OUTPUT_V3).dropna()
    fields = df_base[["Field_ID", "lat", "lon"]].drop_duplicates().reset_index(drop=True)
    fc = build_feature_collection(fields)

    all_years = []
    for year in TERRACLIMATE_YEARS:
        logger.info(f"  Processing {year}...")
        tc = ee.ImageCollection("IDAHO_EPSCOR/TERRACLIMATE").filterDate(f"{year}-01-01", f"{year}-12-31")
        climate_img = ee.Image.cat([
            tc.select("tmmx").mean().rename("temp_mean"),
            tc.select("pr").sum().rename("precip_sum"),
            tc.select("aet").mean().rename("aet_mean"),
            tc.select("pet").mean().rename("pet_mean"),
            tc.select("def").mean().rename("def_mean"),
            tc.select("soil").mean().rename("soil_moisture"),
            tc.select("vpd").mean().rename("vpd_mean"),
            tc.select("srad").mean().rename("srad_mean"),
            tc.select("vs").mean().rename("wind_mean"),
        ])
        climate_df = sample_image(climate_img, fc, scale=4000)
        for col, divisor in TERRACLIMATE_SCALING.items():
            if col in climate_df.columns: climate_df[col] = climate_df[col] / divisor

        df_year = df_base.merge(climate_df, on="Field_ID", how="left")
        df_year["Year"] = year
        df_year = add_agronomic_features(df_year)
        all_years.append(df_year)

    final_df = pd.concat(all_years, ignore_index=True).dropna()
    final_df.to_csv(OUTPUT_MULTIYEAR, index=False)
    logger.info(f"Step 3 complete. Saved to {OUTPUT_MULTIYEAR}")

# ... (Additional Sentinel/SAR logic can be added here following same pattern)

def main():
    logger.info("Starting Egypt Crop Data Pipeline")
    try:
        # Check for local data
        if not os.path.exists(CROPGRIDS_FOLDER):
            logger.error(f"Folder {CROPGRIDS_FOLDER} not found. Please place NetCDF files there.")
            return

        step1_extract_crops()
        step2_soilgrids()
        step3_terraclimate()
        # step4, step5, step6...
        logger.info("Pipeline executed successfully (Base steps).")
    except Exception as e:
        logger.error(f"Pipeline failed: {e}")

if __name__ == "__main__":
    main()
