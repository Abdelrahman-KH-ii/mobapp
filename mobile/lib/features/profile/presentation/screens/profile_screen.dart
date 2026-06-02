import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/providers/locale_provider.dart';
import 'package:farmtec/core/providers/theme_provider.dart';
import 'package:farmtec/features/farm/presentation/providers/farm_provider.dart';
import 'package:farmtec/core/services/notification_settings_service.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/profile/presentation/screens/support_info_screen.dart';
import 'package:farmtec/features/profile/presentation/widgets/profile_change_password_sheet.dart';
import 'package:farmtec/features/profile/presentation/widgets/profile_edit_profile_sheet.dart';
import 'package:farmtec/features/profile/presentation/widgets/profile_language_picker.dart';
import 'package:farmtec/features/profile/presentation/widgets/profile_section_title.dart';
import 'package:farmtec/features/profile/presentation/widgets/profile_settings_tile.dart';
import 'package:farmtec/features/profile/presentation/widgets/profile_stat_card.dart';
import 'package:farmtec/features/profile/presentation/widgets/profile_switch_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const routeName = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final farmService = Provider.of<FarmProvider>(context);
    final notificationSettings = Provider.of<NotificationSettingsService>(
      context,
    );
    final l = AppLocalizations.of(context);
    final farm = farmService.selectedFarm;
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primary;
    final subColor = isDark ? Pallete.darkTextSecondary : Pallete.textSecondary;
    final bgColor = isDark ? Pallete.darkBackground : Pallete.background;
    final cardColor = isDark ? Pallete.darkCard : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            backgroundColor:
                isDark ? Pallete.darkSurface : const Color(0xFF1B4332),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.white),
                onPressed: () => _showEditProfile(context, l),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isDark
                            ? [Pallete.darkSurface, const Color(0xFF0A1A0E)]
                            : [
                              const Color(0xFF1B4332),
                              const Color(0xFF2D6A4F),
                            ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(30),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withAlpha(100),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ahmed Al-Rashid',
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Senior Farm Manager · 8 years',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '📍 ${farm?.name ?? "North Region"} · ${farm?.area ?? "42.2 ha"}',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Farm Stats
                  ProfileSectionTitle(l.tr('farm_statistics'), isDark: isDark),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ProfileStatCard(
                        farm?.area ?? '42.2 ha',
                        l.tr('total_area'),
                        Icons.map_rounded,
                        const Color(0xFF4CAF50),
                        isDark: isDark,
                        cardColor: cardColor,
                      ),
                      const SizedBox(width: 10),
                      ProfileStatCard(
                        farmService.farms.length.toString(),
                        l.tr('farms'),
                        Icons.terrain_rounded,
                        const Color(0xFF2196F3),
                        isDark: isDark,
                        cardColor: cardColor,
                      ),
                      const SizedBox(width: 10),
                      ProfileStatCard(
                        '87%',
                        l.tr('efficiency'),
                        Icons.trending_up_rounded,
                        const Color(0xFFFF9800),
                        isDark: isDark,
                        cardColor: cardColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Appearance
                  ProfileSectionTitle(l.tr('appearance'), isDark: isDark),
                  const SizedBox(height: 10),
                  ProfileSwitchTile(
                    icon: Icons.dark_mode_rounded,
                    label: l.tr('dark_mode'),
                    value: isDark,
                    onChanged: (_) => themeProvider.toggle(),
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),

                  // Language
                  ProfileSectionTitle(l.tr('language'), isDark: isDark),
                  const SizedBox(height: 10),
                  ProfileLanguagePicker(
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                    subColor: subColor,
                    localeProvider: localeProvider,
                  ),
                  const SizedBox(height: 24),

                  // Account
                  ProfileSectionTitle(l.tr('account'), isDark: isDark),
                  const SizedBox(height: 10),
                  ProfileSettingsTile(
                    icon: Icons.person_outline_rounded,
                    label: l.tr('edit_profile'),
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                    onTap: () => _showEditProfile(context, l),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.lock_outline_rounded,
                    label: l.tr('change_password'),
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                    onTap: () => _showChangePassword(context, l),
                  ),
                  const SizedBox(height: 24),

                  // Notifications
                  ProfileSectionTitle(l.tr('notifications'), isDark: isDark),
                  const SizedBox(height: 10),
                  ProfileSwitchTile(
                    icon: Icons.notifications_outlined,
                    label: l.tr('push_notifications'),
                    value: notificationSettings.pushEnabled,
                    onChanged: notificationSettings.setPushEnabled,
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                  ),
                  ProfileSwitchTile(
                    icon: Icons.wb_cloudy_outlined,
                    label: l.tr('weather_alerts'),
                    value: notificationSettings.weatherSwitchValue,
                    onChanged: notificationSettings.setWeatherAlerts,
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                  ),
                  ProfileSwitchTile(
                    icon: Icons.show_chart_rounded,
                    label: l.tr('market_price_alerts'),
                    value: notificationSettings.marketSwitchValue,
                    onChanged: notificationSettings.setMarketPriceAlerts,
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),

                  // Support
                  ProfileSectionTitle(l.tr('support'), isDark: isDark),
                  const SizedBox(height: 10),
                  ProfileSettingsTile(
                    icon: Icons.help_outline_rounded,
                    label: l.tr('help_faq'),
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          SupportInfoScreen.helpRouteName,
                        ),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    label: l.tr('privacy_policy'),
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          SupportInfoScreen.privacyRouteName,
                        ),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.info_outline_rounded,
                    label: l.tr('about_us'),
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          SupportInfoScreen.aboutRouteName,
                        ),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.contact_support_outlined,
                    label: l.tr('contact'),
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                    onTap:
                        () => Navigator.pushNamed(
                          context,
                          SupportInfoScreen.contactRouteName,
                        ),
                  ),
                  ProfileSettingsTile(
                    icon: Icons.info_outline_rounded,
                    label: l.tr('app_version'),
                    trailing: 'v1.0.0',
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),

                  // Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(
                          color: Color(0xFFDC2626),
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _confirmLogout(context, l),
                      icon: const Icon(Icons.logout_rounded),
                      label: Text(
                        l.tr('sign_out'),
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfile(BuildContext context, AppLocalizations l) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileEditProfileSheet(isDark: isDark, l: l),
    );
  }

  void _showChangePassword(BuildContext context, AppLocalizations l) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfileChangePasswordSheet(isDark: isDark, l: l),
    );
  }

  void _confirmLogout(BuildContext context, AppLocalizations l) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: isDark ? Pallete.darkCard : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              l.tr('sign_out_confirm'),
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w800,
                color: isDark ? Pallete.darkTextPrimary : Pallete.primary,
              ),
            ),
            content: Text(
              l.tr('sign_out_message'),
              style: GoogleFonts.manrope(
                fontSize: 14,
                color:
                    isDark ? Pallete.darkTextSecondary : Pallete.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l.tr('cancel'),
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    color: Pallete.primary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'login',
                    (_) => false,
                  );
                },
                child: Text(
                  l.tr('sign_out'),
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
    );
  }
}
