import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/my_farm_card_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmSoilMetricsCard extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subColor;

  const FarmSoilMetricsCard({
    super.key,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
  });

  static const _metrics = [
    {
      'label': 'Nitrogen (N)',
      'value': '68 ppm',
      'progress': 0.68,
      'color': Color(0xFF4CAF50),
    },
    {
      'label': 'Phosphorus (P)',
      'value': '45 ppm',
      'progress': 0.45,
      'color': Color(0xFF2196F3),
    },
    {
      'label': 'Potassium (K)',
      'value': '82 ppm',
      'progress': 0.82,
      'color': Color(0xFFFF9800),
    },
    {
      'label': 'pH Level',
      'value': '6.5',
      'progress': 0.65,
      'color': Color(0xFF9C27B0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: myFarmCardDecoration(isDark, cardColor),
      child: Column(
        children: _metrics
            .map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l.isArabic && m['label'] == 'Nitrogen (N)'
                              ? 'نيتروجين (N)'
                              : l.isArabic && m['label'] == 'Phosphorus (P)'
                                  ? 'فوسفور (P)'
                                  : l.isArabic && m['label'] == 'Potassium (K)'
                                      ? 'بوتاسيوم (K)'
                                      : l.isArabic && m['label'] == 'pH Level'
                                          ? 'مستوى الحموضة (pH)'
                                          : m['label'] as String,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: subColor,
                          ),
                        ),
                        Text(
                          l.convertNumbers(m['value'] as String),
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: m['progress'] as double,
                        minHeight: 6,
                        backgroundColor: isDark
                            ? Pallete.darkSurfaceVariant
                            : const Color(0xFFEEF2EC),
                        valueColor: AlwaysStoppedAnimation(
                          m['color'] as Color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
