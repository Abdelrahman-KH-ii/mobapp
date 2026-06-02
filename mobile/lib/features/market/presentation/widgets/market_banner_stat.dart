import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketBannerStat extends StatelessWidget {
  final String name;
  final String price;
  final String change;
  final bool isUp;

  const MarketBannerStat(
    this.name,
    this.price,
    this.change,
    this.isUp, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final translatedName = l.tr(name.toLowerCase().replaceAll(' ', '_'));
    return Column(
      children: [
        Text(
          translatedName,
          style: GoogleFonts.manrope(
            fontSize: 9,
            color: Colors.white54,
            letterSpacing: 0.5,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          price,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          change,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isUp ? const Color(0xFF86EFAC) : const Color(0xFFFCA5A5),
          ),
        ),
      ],
    );
  }
}
