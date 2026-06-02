import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/moisture_circle_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoistureGauge extends StatelessWidget {
  final bool isDark;
  final Color textColor;

  const MoistureGauge({
    super.key,
    required this.isDark,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 76,
          height: 76,
          child: CustomPaint(
            painter: MoistureCirclePainter(0.74, isDark),
            child: Center(
              child: Text(
                '74%',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Moisture',
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? Pallete.darkTextSecondary : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
