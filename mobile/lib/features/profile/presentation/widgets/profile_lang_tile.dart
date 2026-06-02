import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileLangTile extends StatelessWidget {
  final String label;
  final String code;
  final bool isDark;
  final bool isActive;
  final Color textColor;
  final VoidCallback onTap;

  const ProfileLangTile({
    super.key,
    required this.label,
    required this.code,
    required this.isDark,
    required this.textColor,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (isActive ? Pallete.primary : Pallete.textHint).withAlpha(15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            code.toUpperCase(),
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isActive ? Pallete.primary : Pallete.textHint,
            ),
          ),
        ),
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
          isActive
              ? const Icon(
                Icons.check_circle_rounded,
                color: Pallete.primary,
                size: 20,
              )
              : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onTap: onTap,
    );
  }
}
