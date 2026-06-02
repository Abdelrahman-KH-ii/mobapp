import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/market/data/models/commodity_model.dart';
import 'package:farmtec/features/market/data/repositories/market_repository_impl.dart';
import 'package:farmtec/features/market/domain/repositories/market_repository.dart';
import 'package:farmtec/features/market/presentation/widgets/market_banner.dart';
import 'package:farmtec/features/market/presentation/widgets/market_commodity_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketView extends StatefulWidget {
  const MarketView({super.key, this.bottomPadding = 100});

  final double bottomPadding;

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  late Future<List<CommodityModel>> _commoditiesFuture;
  final MarketRepository _repository = MarketRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _commoditiesFuture = _repository.fetchCommodities();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primaryColor;
    final l = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.tr('market_prices'),
                style: GoogleFonts.manrope(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              Text(
                l.tr('market_subtitle'),
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: isDark
                      ? Pallete.darkTextSecondary
                      : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: FutureBuilder<List<CommodityModel>>(
            future: _commoditiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    l.tr('failed_to_load_market'),
                    style: GoogleFonts.manrope(color: Colors.grey),
                  ),
                );
              }

              final items = snapshot.data!;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MarketBanner(items: items),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: MarketCommodityList(
                      items: items,
                      bottomPadding: widget.bottomPadding,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
