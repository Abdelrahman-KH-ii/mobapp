import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  final bool isDark;
  final Color cardColor;
  final Color textColor;

  const ProfileSettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 20 : 8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Pallete.primary.withAlpha(15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Pallete.primary, size: 18),
        ),
        title: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        trailing:
            trailing != null
                ? Text(
                  trailing!,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color:
                        isDark
                            ? Pallete.darkTextSecondary
                            : const Color(0xFF9CA3AF),
                  ),
                )
                : Icon(
                  Icons.chevron_right_rounded,
                  color:
                      isDark
                          ? Pallete.darkTextTertiary
                          : const Color(0xFFBDBDBD),
                ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
