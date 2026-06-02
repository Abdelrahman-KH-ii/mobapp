import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/chat/data/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == ChatSender.user;
    if (isUser) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 48),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Pallete.primary,
                  borderRadius: BorderRadius.circular(18).copyWith(
                    bottomRight: const Radius.circular(4),
                  ),
                ),
                child: Text(
                  message.text,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: isDark ? Pallete.darkCard : Pallete.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.eco_rounded,
              size: 16,
              color: isDark ? Pallete.chartGreen : Pallete.primary,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FarmBrain',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? Pallete.darkTextSecondary
                        : Pallete.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.text,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: isDark
                        ? Pallete.darkTextPrimary
                        : Pallete.textPrimary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
