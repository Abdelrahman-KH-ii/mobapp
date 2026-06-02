import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/services/crop_lifecycle_service.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/dashboard_card_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CropLifecycleCard extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subColor;
  final String crop;
  final DateTime? plantedAt;

  const CropLifecycleCard({
    super.key,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
    required this.crop,
    this.plantedAt,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (plantedAt == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: dashboardCardDecoration(isDark, cardColor),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: subColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l.tr('set_planting_date_hint'),
                style: GoogleFonts.manrope(fontSize: 13, color: subColor),
              ),
            ),
          ],
        ),
      );
    }

    final status = CropLifecycleService.statusFor(crop, plantedAt!);
    final harvest = status.expectedHarvest;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: dashboardCardDecoration(isDark, cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${l.tr(CropLifecycleService.cropL10nKey(crop))} • ${status.currentStage.name}',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Pallete.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  l.convertNumbers(
                    l.trParams('day_n', {'n': status.currentDay.toString()}),
                  ),
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Pallete.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: status.progress,
              minHeight: 8,
              backgroundColor: isDark
                  ? Pallete.darkSurfaceVariant
                  : const Color(0xFFEEF2EC),
              valueColor: const AlwaysStoppedAnimation(Pallete.primary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.tr('sowing'),
                style: GoogleFonts.manrope(fontSize: 10, color: subColor),
              ),
              Text(
                '${l.tr('expected_harvest')}: ${l.convertNumbers('${harvest.month}/${harvest.day}')}',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
