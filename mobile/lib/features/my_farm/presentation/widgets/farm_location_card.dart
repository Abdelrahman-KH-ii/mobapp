import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/map/satellite_map_tiles.dart';
import 'package:farmtec/core/services/farm_history_service.dart';
import 'package:farmtec/core/services/agromonitoring_client.dart';
import 'package:farmtec/core/services/ndvi_service.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/farm/domain/entities/farm.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/my_farm_card_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class FarmLocationCard extends StatefulWidget {
  final Farm farm;
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subColor;

  const FarmLocationCard({
    super.key,
    required this.farm,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  State<FarmLocationCard> createState() => _FarmLocationCardState();
}

class _FarmLocationCardState extends State<FarmLocationCard> {
  bool _showNDVI = false;
  bool _ndviLoading = false;
  NdviAnalysisResult? _ndviResult;

  List<Polygon> _ndviPolygons(NdviAnalysisResult result) {
    final fieldOutline = Polygon(
      points: result.fieldBoundary,
      borderStrokeWidth: 2.5,
      borderColor: Colors.white,
      color: Colors.transparent,
    );

    final zones = result.zones.map((zone) {
      final color = NdviService.colorForNdvi(zone.ndvi);
      return Polygon(
        points: zone.polygon,
        color: color.withAlpha(110),
        borderColor: color.withAlpha(230),
        borderStrokeWidth: 1.2,
      );
    });

    return [fieldOutline, ...zones];
  }

  Future<void> _onNdviTap() async {
    final l = AppLocalizations.of(context);
    final hasCoords = widget.farm.lat != 0 || widget.farm.lng != 0;

    if (!hasCoords) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.tr('ndvi_no_location'))),
      );
      return;
    }

    if (_showNDVI) {
      setState(() => _showNDVI = false);
      return;
    }

    setState(() => _ndviLoading = true);

    try {
      final result = await NdviService().analyze(
        farmId: widget.farm.id,
        lat: widget.farm.lat,
        lng: widget.farm.lng,
        area: widget.farm.area,
      );
      if (!mounted) return;

      setState(() {
        _ndviResult = result;
        _showNDVI = true;
        _ndviLoading = false;
      });

      final ndviLabel = result.averageNdvi.toStringAsFixed(2);
      await Provider.of<FarmHistoryService>(context, listen: false).addOperation(
        FarmOperation(
          id: 'op_${DateTime.now().microsecondsSinceEpoch}',
          farmId: widget.farm.id,
          type: OperationType.ndviScan,
          title: 'NDVI Scan',
          titleKey: 'ndvi_scan',
          description: l.trParams('ndvi_scan_result', {'value': ndviLabel}),
          timestamp: DateTime.now(),
        ),
      );
    } on AgromonitoringException catch (e) {
      if (mounted) {
        setState(() => _ndviLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _ndviLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.tr('failed_to_load'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasCoords = widget.farm.lat != 0 || widget.farm.lng != 0;
    final center = LatLng(widget.farm.lat, widget.farm.lng);

    return Container(
      decoration: myFarmCardDecoration(widget.isDark, widget.cardColor),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (hasCoords)
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: center,
                      initialZoom: 14,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                      ),
                    ),
                    children: [
                      ...SatelliteMapTiles.layers(),
                      if (_showNDVI && _ndviResult != null)
                        PolygonLayer(
                          polygons: _ndviPolygons(_ndviResult!),
                        ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: center,
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Pallete.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(60),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.agriculture_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_ndviLoading)
                    Container(
                      color: Colors.black.withAlpha(80),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(color: Colors.white),
                            const SizedBox(height: 10),
                            Text(
                              l.tr('ndvi_analyzing'),
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(150),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          l.tr('map_satellite_attribution'),
                          style: GoogleFonts.manrope(
                            fontSize: 8,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.cardColor.withAlpha(0),
                            widget.cardColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_showNDVI && _ndviResult != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.cardColor.withAlpha(220),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.trParams(
                                'ndvi_scan_result',
                                {
                                  'value': l.convertNumbers(
                                    _ndviResult!.averageNdvi.toStringAsFixed(2),
                                  ),
                                },
                              ),
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: widget.textColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  color: const Color(0xFF4CAF50),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l.tr('ndvi_healthy'),
                                  style: GoogleFonts.manrope(
                                    fontSize: 10,
                                    color: widget.textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  color: const Color(0xFFF44336),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l.tr('ndvi_stressed'),
                                  style: GoogleFonts.manrope(
                                    fontSize: 10,
                                    color: widget.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? Pallete.darkSurfaceVariant
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.satellite_alt_rounded,
                    color: Pallete.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.tr('gps_coordinates'),
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: widget.textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.isArabic
                            ? l.trParams('lat_lng_format_ar', {
                                'lat': l.convertNumbers(
                                  widget.farm.lat.toStringAsFixed(4),
                                ),
                                'lng': l.convertNumbers(
                                  widget.farm.lng.toStringAsFixed(4),
                                ),
                              })
                            : l.trParams('lat_lng_format', {
                                'lat': widget.farm.lat.toStringAsFixed(4),
                                'lng': widget.farm.lng.toStringAsFixed(4),
                              }),
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: widget.subColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _ndviLoading ? null : _onNdviTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _showNDVI
                          ? Pallete.primary
                          : (widget.isDark
                              ? Pallete.darkSurfaceVariant
                              : const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _ndviLoading
                        ? const SizedBox(
                            width: 36,
                            height: 14,
                            child: Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            'NDVI',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: _showNDVI ? Colors.white : widget.subColor,
                            ),
                          ),
                  ),
                ),
                if (_showNDVI && _ndviResult != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l.tr('live'),
                          style: GoogleFonts.manrope(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF22C55E),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
