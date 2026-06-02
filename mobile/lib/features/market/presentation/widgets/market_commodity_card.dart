import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/market/data/models/commodity_model.dart';
import 'package:farmtec/features/market/presentation/widgets/market_spark_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketCommodityCard extends StatelessWidget {
  final CommodityModel item;

  const MarketCommodityCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final col = item.isUp ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final bg = item.isUp ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2);
    final tileColor = isDark ? Pallete.darkCard : Colors.white;
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primaryColor;
    final subtitleColor =
        isDark ? Pallete.darkTextSecondary : const Color(0xFF9CA3AF);
    final translatedName = l.tr(item.name.toLowerCase().replaceAll(' ', '_'));
    final perUnit = l.isArabic ? 'لكل طن' : 'per ton';

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) {
          final isDarkSheet = Theme.of(context).brightness == Brightness.dark;
          final sheetBg = isDarkSheet ? Pallete.darkSurface : Colors.white;
          final sheetText =
              isDarkSheet ? Pallete.darkTextPrimary : Pallete.primaryColor;
          final sheetSub = isDarkSheet
              ? Pallete.darkTextSecondary
              : const Color(0xFF9CA3AF);
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: sheetBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDarkSheet
                          ? Pallete.darkOutline
                          : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        item.isUp
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: col,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translatedName,
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: sheetText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            perUnit,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: sheetSub,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l.tr('current_price'),
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            color: sheetSub,
                          ),
                        ),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: sheetText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${item.isUp ? '+' : ''}${item.changePercent}%',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: col,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: MarketSparkChartPainter(item.sparkData, col),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l.tr('forecast_details'),
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: sheetText,
                  ),
                ),
                const SizedBox(height: 12),
                ...item.forecastDetails.map((detail) {
                  final year = detail['year'];
                  final quarter = detail['quarter'];
                  final price = (detail['price'] as num).toDouble();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Q$quarter $year',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDarkSheet
                                ? Pallete.darkTextTertiary
                                : const Color(0xFF4B5563),
                          ),
                        ),
                        Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: sheetText,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isDark
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
          border: isDark ? Border.all(color: Pallete.darkOutline) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                item.isUp
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: col,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translatedName,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  Text(
                    perUnit,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 58,
              height: 28,
              child: CustomPaint(
                painter: MarketSparkChartPainter(item.sparkData, col),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l.tr('current_price'),
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    color: subtitleColor,
                  ),
                ),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    '${item.isUp ? '+' : ''}${item.changePercent}%',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: col,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
