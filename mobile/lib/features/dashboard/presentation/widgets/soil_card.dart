import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/dashboard/data/models/dashboard_models.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/dashboard_card_style.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/moisture_gauge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SoilCard extends StatelessWidget {
  final List<SoilMetricModel> metrics;
  final bool isDark;
  final Color cardColor;
  final Color textColor;

  const SoilCard({
    super.key,
    required this.metrics,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
  });

  static const _colors = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFF9800),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: dashboardCardDecoration(isDark, cardColor),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: List.generate(
                metrics.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            metrics[i].label,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Pallete.darkTextSecondary
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                          Text(
                            metrics[i].value,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: metrics[i].progress,
                          minHeight: 7,
                          backgroundColor: isDark
                              ? Pallete.darkSurfaceVariant
                              : const Color(0xFFEEF2EC),
                          valueColor: AlwaysStoppedAnimation(_colors[i]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          MoistureGauge(isDark: isDark, textColor: textColor),
        ],
      ),
    );
  }
}
