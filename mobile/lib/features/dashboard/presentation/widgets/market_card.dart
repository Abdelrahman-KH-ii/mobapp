import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/dashboard_card_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketCard extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> future;
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subColor;

  const MarketCard({
    super.key,
    required this.future,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: dashboardCardDecoration(isDark, cardColor),
            child: const Center(
              child: CircularProgressIndicator(color: Pallete.primary),
            ),
          );
        }
        if (!snap.hasData || snap.data!.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: dashboardCardDecoration(isDark, cardColor),
            child: Center(
              child: Text(
                'No market data',
                style: GoogleFonts.manrope(color: subColor),
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: dashboardCardDecoration(isDark, cardColor),
          child: Column(
            children: snap.data!
                .map(
                  (e) => ListTile(
                    dense: true,
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: e['isUp']
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        e['isUp']
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: e['isUp']
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                        size: 18,
                      ),
                    ),
                    title: Text(
                      e['name'],
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          e['price'],
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        Text(
                          e['change'],
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: e['isUp']
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
