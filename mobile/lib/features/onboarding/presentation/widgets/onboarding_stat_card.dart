import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/onboarding/data/onboarding_page_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingStatCard extends StatelessWidget {
  const OnboardingStatCard({
    super.key,
    required this.data,
    this.highlight = false,
  });

  final OnboardingCardData data;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (data.emoji.isNotEmpty) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: highlight
                    ? Pallete.primaryColor.withOpacity(0.1)
                    : const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(data.emoji, style: const TextStyle(fontSize: 15)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.label,
                style: GoogleFonts.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.value,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: highlight
                      ? Pallete.primaryColor
                      : const Color(0xFF111827),
                ),
              ),
              if (data.subtitle != null)
                Text(
                  data.subtitle!,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    color: const Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
