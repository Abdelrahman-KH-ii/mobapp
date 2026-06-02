import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/ai_models/presentation/widgets/ai_engine_banner.dart';
import 'package:farmtec/features/ai_models/presentation/widgets/ai_model_definition.dart';
import 'package:farmtec/features/ai_models/presentation/widgets/ai_model_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIModelsView extends StatelessWidget {
  const AIModelsView({super.key});

  static const _models = [
    AIModelDefinition(
      name: 'Crop Recommendation',
      desc: 'Predicts optimal crop based on GPS location',
      icon: Icons.eco_rounded,
      color: Color(0xFF4CAF50),
      apiUrl: 'https://youssef-d1aa-croprecommend.hf.space/predict',
      fields: [
        AIModelFieldDefinition(
          key: 'lat',
          label: 'Latitude',
          hint: '30.0444',
          type: TextInputType.numberWithOptions(decimal: true),
        ),
        AIModelFieldDefinition(
          key: 'lon',
          label: 'Longitude',
          hint: '31.2357',
          type: TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    ),
    AIModelDefinition(
      name: 'Yield Prediction',
      desc: 'Forecasts crop yield from location, year & crop type',
      icon: Icons.bar_chart_rounded,
      color: Color(0xFFFF9800),
      apiUrl: 'https://youssef-d1aa-yieldpredict.hf.space/predict_yield',
      fields: [
        AIModelFieldDefinition(
          key: 'lat',
          label: 'Latitude',
          hint: '30.0444',
          type: TextInputType.numberWithOptions(decimal: true),
        ),
        AIModelFieldDefinition(
          key: 'lon',
          label: 'Longitude',
          hint: '31.2357',
          type: TextInputType.numberWithOptions(decimal: true),
        ),
        AIModelFieldDefinition(
          key: 'year',
          label: 'Year',
          hint: '2026',
          type: TextInputType.number,
        ),
        AIModelFieldDefinition(
          key: 'crop',
          label: 'Crop',
          hint: 'Wheat',
          type: TextInputType.text,
        ),
      ],
    ),
    AIModelDefinition(
      name: 'Irrigation Planner',
      desc: 'Calculates irrigation needs from GPS coordinates',
      icon: Icons.water_rounded,
      color: Color(0xFF03A9F4),
      apiUrl: 'https://B1R-14N15-irrigation.hf.space/predict',
      fields: [
        AIModelFieldDefinition(
          key: 'lat',
          label: 'Latitude',
          hint: '30.0444',
          type: TextInputType.numberWithOptions(decimal: true),
        ),
        AIModelFieldDefinition(
          key: 'lon',
          label: 'Longitude',
          hint: '31.2357',
          type: TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    ),
    AIModelDefinition(
      name: 'Market Forecast',
      desc: 'Commodity price forecast from live market data',
      icon: Icons.show_chart_rounded,
      color: Color(0xFF9C27B0),
      apiUrl: 'https://b1r-14n15-forecast.hf.space/forecast',
      fields: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primary;
    final subColor = isDark ? Pallete.darkTextSecondary : Pallete.textSecondary;
    final cardColor = isDark ? Pallete.darkCard : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.tr('ai_models'),
                      style: GoogleFonts.manrope(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.tr('tap_model_subtitle'),
                      style: GoogleFonts.manrope(fontSize: 13, color: subColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l.isArabic
                          ? '${_models.length} نشط'
                          : '${_models.length} LIVE',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AiEngineBanner(isDark: isDark),
          const SizedBox(height: 24),
          ...List.generate(
            _models.length,
            (i) => AiModelTile(
              model: _models[i],
              isDark: isDark,
              cardColor: cardColor,
              textColor: textColor,
              subColor: subColor,
            ),
          ),
        ],
      ),
    );
  }
}
