import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/farm/domain/entities/farm.dart';
import 'package:farmtec/features/farm/presentation/extensions/farm_ui_extensions.dart';
import 'package:farmtec/features/farm_selection/presentation/widgets/farm_tag.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmSelectionCard extends StatelessWidget {
  final Farm farm;
  final bool isSelected;
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subColor;
  final VoidCallback onTap;
  const FarmSelectionCard({
    super.key,
    required this.farm,
    required this.isSelected,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Pallete.primary : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? Pallete.primary.withAlpha(25)
                      : Colors.black.withAlpha(8),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: farm.healthColor.withAlpha(25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.grass_rounded,
                color: farm.healthColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farm.name,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      FarmTag(farm.crop, isDark: isDark, color: subColor),
                      const SizedBox(width: 6),
                      FarmTag(farm.area, isDark: isDark, color: subColor),
                      if (farm.lat != 0) ...[
                        const SizedBox(width: 6),
                        FarmTag('📍 GPS', isDark: isDark, color: subColor),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Icon(farm.healthIcon, color: farm.healthColor, size: 22),
                const SizedBox(height: 4),
                Text(
                  farm.healthLabel,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: farm.healthColor,
                  ),
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Pallete.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
