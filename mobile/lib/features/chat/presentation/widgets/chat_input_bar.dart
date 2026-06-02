import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInputBar extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l;
  final TextEditingController textController;
  final FocusNode focusNode;
  final ValueChanged<String> onSend;
  final bool isSending;

  const ChatInputBar({
    super.key,
    required this.isDark,
    required this.l,
    required this.textController,
    required this.focusNode,
    required this.onSend,
    this.isSending = false,
  });

  @override
  Widget build(BuildContext context) {
    final barBg = isDark ? Pallete.darkSurface : Colors.white;
    final fieldBg = isDark ? Pallete.darkSurfaceVariant : const Color(0xFFF3F4ED);
    final borderClr = isDark ? Pallete.darkOutline : const Color(0xFFE2E3DC);
    final textClr = isDark ? Pallete.darkTextPrimary : Pallete.textPrimary;
    final hintClr = isDark ? Pallete.darkTextTertiary : Pallete.textHint;

    return Container(
      padding: EdgeInsets.fromLTRB(
        14,
        10,
        14,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: barBg,
        border: Border(top: BorderSide(color: borderClr, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              style: GoogleFonts.manrope(fontSize: 14, color: textClr),
              cursorColor: isDark ? Pallete.chartGreen : Pallete.primary,
              decoration: InputDecoration(
                hintText: l.tr('ask_anything'),
                hintStyle: GoogleFonts.manrope(fontSize: 14, color: hintClr),
                filled: true,
                fillColor: fieldBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: borderClr, width: 0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: borderClr, width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: isDark ? Pallete.chartGreen : Pallete.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: isDark ? Pallete.darkTextTertiary : Pallete.textHint,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
                isDense: true,
              ),
              enabled: !isSending,
              onSubmitted: isSending ? null : onSend,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: isSending ? null : () => onSend(textController.text),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: (isDark ? Pallete.chartGreen : Pallete.primary)
                    .withAlpha(isSending ? 120 : 255),
                shape: BoxShape.circle,
              ),
              child: isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
