import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmSheetField extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final IconData icon;
  final bool isDark;
  final Color fillColor;
  final Color textColor;
  final TextInputType type;
  const FarmSheetField({
    super.key,
    required this.label,
    required this.ctrl,
    required this.icon,
    required this.isDark,
    required this.fillColor,
    required this.textColor,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      style: GoogleFonts.manrope(fontSize: 14, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.manrope(fontSize: 13, color: Pallete.textHint),
        prefixIcon: Icon(icon, size: 18, color: textColor),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Pallete.primary, width: 1.5),
        ),
      ),
    );
  }
}

class FarmSheetDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final IconData icon;
  final bool isDark;
  final Color fillColor;
  final Color textColor;

  const FarmSheetDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
    required this.isDark,
    required this.fillColor,
    required this.textColor,
  });

  String _getEmoji(String crop) {
    switch (crop.toLowerCase()) {
      case 'wheat':
        return '🌾';
      case 'maize':
        return '🌽';
      case 'rice':
        return '🍚';
      case 'tomato':
        return '🍅';
      case 'potato':
        return '🥔';
      case 'mango':
        return '🥭';
      case 'jowar (sorghum)':
        return '🌿';
      case 'green fodder':
        return '🌱';
      default:
        return '🌱';
    }
  }

  Color _getBgColor(String crop) {
    if (isDark) return Pallete.darkSurfaceVariant;
    switch (crop.toLowerCase()) {
      case 'wheat':
        return const Color(0xFFFEF3C7);
      case 'maize':
        return const Color(0xFFECFCCB);
      case 'rice':
        return const Color(0xFFCFFAFE);
      case 'tomato':
        return const Color(0xFFFEE2E2);
      case 'potato':
        return const Color(0xFFFEF08A);
      case 'mango':
        return const Color(0xFFFEF9C3);
      case 'jowar (sorghum)':
        return const Color(0xFFD1FAE5);
      case 'green fodder':
        return const Color(0xFFDCFCE7);
      default:
        return const Color(0xFFDCFCE7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _getBgColor(e),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getEmoji(e),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context).tr(e.toLowerCase()) ?? e,
                        style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
      onChanged: onChanged,
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: textColor),
      style: GoogleFonts.manrope(fontSize: 15, color: textColor),
      dropdownColor: isDark ? Pallete.darkCard : Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.manrope(fontSize: 13, color: Pallete.textHint),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Pallete.primary, width: 1.5),
        ),
      ),
    );
  }
}
