import 'package:farmtec/features/market/data/models/commodity_model.dart';
import 'package:farmtec/features/market/presentation/widgets/market_banner_stat.dart';
import 'package:flutter/material.dart';

class MarketBanner extends StatelessWidget {
  final List<CommodityModel> items;

  const MarketBanner({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final item1 = items.isNotEmpty ? items[0] : null;
    final item2 = items.length > 1 ? items[1] : null;
    final item3 = items.length > 2 ? items[2] : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (item1 != null)
            Expanded(
              child: MarketBannerStat(
                item1.name,
                '\$${item1.price.toStringAsFixed(2)}',
                '${item1.isUp ? '+' : ''}${item1.changePercent}%',
                item1.isUp,
              ),
            ),
          if (item1 != null && item2 != null)
            Container(width: 1, height: 36, color: Colors.white24),
          if (item2 != null)
            Expanded(
              child: MarketBannerStat(
                item2.name,
                '\$${item2.price.toStringAsFixed(2)}',
                '${item2.isUp ? '+' : ''}${item2.changePercent}%',
                item2.isUp,
              ),
            ),
          if (item2 != null && item3 != null)
            Container(width: 1, height: 36, color: Colors.white24),
          if (item3 != null)
            Expanded(
              child: MarketBannerStat(
                item3.name,
                '\$${item3.price.toStringAsFixed(2)}',
                '${item3.isUp ? '+' : ''}${item3.changePercent}%',
                item3.isUp,
              ),
            ),
        ],
      ),
    );
  }
}
