import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmSectionLabel extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const FarmSectionLabel({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 7),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      );
}
