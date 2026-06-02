import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/services/farm_history_service.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/farm/presentation/extensions/farm_ui_extensions.dart';
import 'package:farmtec/features/farm/presentation/providers/farm_provider.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/farm_activity_tile.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/farm_hero_card.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/farm_location_card.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/farm_section_label.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/farm_soil_metrics_card.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/farm_stat_card.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/my_farm_card_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyFarmView extends StatelessWidget {
  const MyFarmView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final farmService = Provider.of<FarmProvider>(context);
    final historyService = Provider.of<FarmHistoryService>(context);
    final farm = farmService.selectedFarm;
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primary;
    final subColor = isDark ? Pallete.darkTextSecondary : Pallete.textSecondary;
    final cardColor = isDark ? Pallete.darkCard : Colors.white;

    if (farm == null) {
      return Center(
        child: Text(
          l.tr('no_farm_selected'),
          style: GoogleFonts.manrope(fontSize: 16, color: subColor),
        ),
      );
    }

    final farmOps = historyService.getForFarm(farm.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.tr('my_farm'),
            style: GoogleFonts.manrope(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l.tr('farm_details'),
            style: GoogleFonts.manrope(fontSize: 13, color: subColor),
          ),
          const SizedBox(height: 20),
          FarmHeroCard(
            farm: farm,
            isDark: isDark,
            textColor: textColor,
            subColor: subColor,
          ),
          const SizedBox(height: 20),
          FarmSectionLabel(
            icon: Icons.analytics_rounded,
            title: l.tr('farm_overview'),
            color: textColor,
          ),
          Row(
            children: [
              FarmStatCard(
                icon: Icons.grass_rounded,
                value: l.tr(farm.crop.toLowerCase()),
                label: l.tr('crop_type'),
                color: const Color(0xFF4CAF50),
                isDark: isDark,
                cardColor: cardColor,
              ),
              const SizedBox(width: 10),
              FarmStatCard(
                icon: Icons.map_rounded,
                value: farm.area,
                label: l.tr('total_area'),
                color: const Color(0xFF2196F3),
                isDark: isDark,
                cardColor: cardColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              FarmStatCard(
                icon: farm.healthIcon,
                value: l.isArabic && farm.healthLabel == 'Optimal'
                    ? 'مثالي'
                    : (l.isArabic && farm.healthLabel == 'Good'
                        ? 'جيد'
                        : (l.isArabic && farm.healthLabel == 'Needs Water'
                            ? 'يحتاج ماء'
                            : farm.healthLabel)),
                label: l.tr('health'),
                color: farm.healthColor,
                isDark: isDark,
                cardColor: cardColor,
              ),
              const SizedBox(width: 10),
              FarmStatCard(
                icon: Icons.schedule_rounded,
                value: farm.lastScan,
                label: l.tr('last_scan'),
                color: const Color(0xFF9C27B0),
                isDark: isDark,
                cardColor: cardColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (farm.lat != 0 || farm.lng != 0) ...[
            FarmSectionLabel(
              icon: Icons.location_on_rounded,
              title: l.tr('location'),
              color: textColor,
            ),
            const SizedBox(height: 12),
            FarmLocationCard(
              farm: farm,
              isDark: isDark,
              cardColor: cardColor,
              textColor: textColor,
              subColor: subColor,
            ),
            const SizedBox(height: 20),
          ],
          FarmSectionLabel(
            icon: Icons.science_rounded,
            title: l.tr('soil_metrics'),
            color: textColor,
          ),
          const SizedBox(height: 12),
          FarmSoilMetricsCard(
            isDark: isDark,
            cardColor: cardColor,
            textColor: textColor,
            subColor: subColor,
          ),
          const SizedBox(height: 20),
          FarmSectionLabel(
            icon: Icons.history_rounded,
            title: l.tr('recent_operations'),
            color: textColor,
          ),
          const SizedBox(height: 12),
          if (farmOps.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: myFarmCardDecoration(isDark, cardColor),
              child: Center(
                child: Text(
                  l.tr('no_recent_activity'),
                  style: GoogleFonts.manrope(fontSize: 13, color: subColor),
                ),
              ),
            )
          else
            ...farmOps.take(5).map(
                  (op) => FarmActivityTile(
                    op: op,
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
