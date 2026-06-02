import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/providers/theme_provider.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/dashboard_icon_button.dart';
import 'package:farmtec/features/farm_selection/presentation/screens/farm_selection_screen.dart';
import 'package:farmtec/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:farmtec/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardHeader extends StatelessWidget {
  final String farmName;
  final bool isDark;
  final Color textColor;
  final Color subColor;

  const DashboardHeader({
    super.key,
    required this.farmName,
    required this.isDark,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).tr('good_morning'),
                style: GoogleFonts.manrope(fontSize: 14, color: subColor),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(
                  context,
                  FarmSelectionScreen.routeName,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      farmName,
                      style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Pallete.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.swap_horiz_rounded,
                        size: 16,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DashboardIconButton(
          icon: themeProvider.isDark
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
          isDark: isDark,
          onTap: () => themeProvider.toggle(),
        ),
        const SizedBox(width: 10),
        DashboardIconButton(
          icon: Icons.notifications_rounded,
          isDark: isDark,
          hasBadge: true,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          ),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Pallete.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Pallete.primary.withAlpha(60),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
