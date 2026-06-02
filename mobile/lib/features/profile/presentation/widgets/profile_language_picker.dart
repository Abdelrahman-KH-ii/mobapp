import 'package:farmtec/core/providers/locale_provider.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/profile/presentation/widgets/profile_lang_tile.dart';
import 'package:flutter/material.dart';

class ProfileLanguagePicker extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subColor;
  final LocaleProvider localeProvider;

  const ProfileLanguagePicker({
    super.key,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
    required this.localeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 20 : 8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileLangTile(
            label: 'English',
            code: 'en',
            isDark: isDark,
            textColor: textColor,
            isActive: localeProvider.locale.languageCode == 'en',
            onTap: () => localeProvider.setLocale(const Locale('en')),
          ),
          Divider(
            height: 1,
            color: isDark ? Pallete.darkOutline : Pallete.neutral200,
          ),
          ProfileLangTile(
            label: 'العربية',
            code: 'ar',
            isDark: isDark,
            textColor: textColor,
            isActive: localeProvider.locale.languageCode == 'ar',
            onTap: () => localeProvider.setLocale(const Locale('ar')),
          ),
        ],
      ),
    );
  }
}
