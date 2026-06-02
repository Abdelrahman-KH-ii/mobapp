import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatSuggestions extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l;
  final ValueChanged<String> onSuggestionTap;

  const ChatSuggestions({
    super.key,
    required this.isDark,
    required this.l,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      l.tr('suggestion_analyze'),
      l.tr('suggestion_irrigation'),
      l.tr('suggestion_disease'),
      l.tr('suggestion_market'),
      l.tr('suggestion_crop'),
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: suggestions.map((s) {
          return GestureDetector(
            onTap: () => onSuggestionTap(s),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Pallete.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Pallete.darkOutline
                      : const Color(0xFFE2E3DC),
                ),
              ),
              child: Text(
                s,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Pallete.darkTextPrimary : Pallete.primary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
