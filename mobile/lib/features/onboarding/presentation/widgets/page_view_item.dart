import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/core/themes/text_styles.dart';
import 'package:farmtec/features/onboarding/data/onboarding_page_model.dart';
import 'package:farmtec/features/onboarding/presentation/widgets/onboarding_feature_row.dart';
import 'package:farmtec/features/onboarding/presentation/widgets/onboarding_image_card.dart';
import 'package:farmtec/features/onboarding/presentation/widgets/onboarding_tag_chip.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({super.key, required this.model});

  final OnboardingPageModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        OnboardingImageCard(model: model),
        const SizedBox(height: 28),
        if (model.tagLabel != null) ...[
          OnboardingTagChip(label: model.tagLabel!),
          const SizedBox(height: 14),
        ],
        Text(
          model.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Pallete.primaryColor,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            model.subtitle,
            textAlign: TextAlign.center,
            style: TextStyles.bodyMedium.copyWith(
              fontSize: 15,
              height: 1.6,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
        if (model.featureItem != null) ...[
          const SizedBox(height: 20),
          OnboardingFeatureRow(feature: model.featureItem!),
        ],
      ],
    );
  }
}
