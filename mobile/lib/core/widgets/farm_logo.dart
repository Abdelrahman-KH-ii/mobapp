import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmLogo extends StatelessWidget {
  const FarmLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Pallete.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.eco_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        Text(
          'FarmTech',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Pallete.primaryColor,
          ),
        ),
      ],
    );
  }
}
