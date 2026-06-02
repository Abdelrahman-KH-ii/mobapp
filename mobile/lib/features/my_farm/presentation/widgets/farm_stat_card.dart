import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/my_farm_card_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isDark;
  final Color cardColor;

  const FarmStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: myFarmCardDecoration(isDark, cardColor),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.convertNumbers(value),
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Pallete.darkTextPrimary : Pallete.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      color: isDark
                          ? Pallete.darkTextSecondary
                          : Pallete.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
