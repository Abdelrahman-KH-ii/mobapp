import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/onboarding/data/onboarding_page_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingFeatureRow extends StatelessWidget {
  const OnboardingFeatureRow({super.key, required this.feature});

  final OnboardingFeature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD1E8CA), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Pallete.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                feature.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Pallete.primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  feature.description,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
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
