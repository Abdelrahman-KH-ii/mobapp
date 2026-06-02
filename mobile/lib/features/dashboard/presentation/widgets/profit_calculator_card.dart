import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/services/yield_prediction_service.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/dashboard_card_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfitCalculatorCard extends StatelessWidget {
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subColor;
  final double marketPrice;

  const ProfitCalculatorCard({
    super.key,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
    required this.marketPrice,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final yieldPrediction = Provider.of<YieldPredictionService>(context);

    final estimatedYield = yieldPrediction.yieldPerHa;
    final totalProfit = estimatedYield * marketPrice;
    final unitLabel = yieldPrediction.unit.replaceAll('/ha', '');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: dashboardCardDecoration(isDark, cardColor),
      child: Column(
        children: [
          _profitRow(
            l.tr('estimated_yield'),
            '${l.convertNumbers(estimatedYield.toStringAsFixed(2))} $unitLabel',
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _profitRow(
            l.tr('current_market_price'),
            '\$${l.convertNumbers(marketPrice.toStringAsFixed(2))}/t',
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 12, color: subColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${l.tr('source')}: ${yieldPrediction.crop} · ${yieldPrediction.field}',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: subColor,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Pallete.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    l.tr('total_expected_profit'),
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Pallete.primary,
                    ),
                  ),
                ),
                Text(
                  '\$${l.convertNumbers(totalProfit.toStringAsFixed(2))}',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Pallete.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profitRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.manrope(fontSize: 13, color: subColor),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor ?? textColor,
          ),
        ),
      ],
    );
  }
}
