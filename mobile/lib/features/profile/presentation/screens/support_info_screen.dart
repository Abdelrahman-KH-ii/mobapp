import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/profile/presentation/widgets/support_info_data.dart';
import 'package:farmtec/features/profile/presentation/widgets/support_info_section_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'package:farmtec/features/profile/presentation/widgets/support_info_data.dart'
    show SupportInfoPage;

class SupportInfoScreen extends StatelessWidget {
  final SupportInfoPage page;
  const SupportInfoScreen({super.key, required this.page});

  static const helpRouteName = 'help-faq';
  static const privacyRouteName = 'privacy-policy';
  static const aboutRouteName = 'about-us';
  static const contactRouteName = 'contact';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Pallete.darkBackground : Pallete.background;
    final cardColor = isDark ? Pallete.darkCard : Colors.white;
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primary;
    final subColor = isDark ? Pallete.darkTextSecondary : Pallete.textSecondary;
    final data = SupportInfoData.forPage(page);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        foregroundColor: textColor,
        title: Text(
          data.title,
          style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 25 : 10),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: data.color.withAlpha(25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(data.icon, color: data.color, size: 26),
                ),
                const SizedBox(height: 14),
                Text(
                  data.heading,
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.summary,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    height: 1.5,
                    color: subColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...data.sections.map(
            (section) => SupportInfoSectionCard(
              section: section,
              cardColor: cardColor,
              textColor: textColor,
              subColor: subColor,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}
