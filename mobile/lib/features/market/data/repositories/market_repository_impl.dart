import 'dart:convert';

import 'package:farmtec/features/market/data/models/commodity_model.dart';
import 'package:farmtec/features/market/domain/repositories/market_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MarketRepositoryImpl implements MarketRepository {
  @override
  Future<List<CommodityModel>> fetchCommodities() async {
    try {
      final response = await http.get(
        Uri.parse('https://b1r-14n15-forecast.hf.space/forecast'),
      );
      if (response.statusCode != 200) return [];

      final data = jsonDecode(response.body) as List<dynamic>;
      final groupedData = <String, List<Map<String, dynamic>>>{};
      for (final item in data) {
        final name = item['commodity'] as String;
        groupedData.putIfAbsent(name, () => []).add(item as Map<String, dynamic>);
      }

      final results = <CommodityModel>[];
      for (final entry in groupedData.entries) {
        final name = entry.key;
        final items = entry.value;
        if (items.isEmpty) continue;

        final prices = items.map((e) => (e['price'] as num).toDouble()).toList();
        var currentPrice = prices.first;
        var currentChange =
            ((prices.last - currentPrice) / currentPrice) * 100;

        var symbol = '';
        var multiplier = 1.0;
        switch (name.toLowerCase()) {
          case 'wheat':
            symbol = 'ZW=F';
            multiplier = 3.84;
          case 'maize':
            symbol = 'ZC=F';
            multiplier = 4.48;
          case 'rice':
            symbol = 'ZR=F';
            multiplier = 285.1;
        }

        if (symbol.isNotEmpty) {
          try {
            final yRes = await http.get(
              Uri.parse('https://query1.finance.yahoo.com/v8/finance/chart/$symbol'),
              headers: {'User-Agent': 'Mozilla/5.0'},
            ).timeout(const Duration(seconds: 5));
            if (yRes.statusCode == 200) {
              final yData = jsonDecode(yRes.body);
              final meta = yData['chart']?['result']?[0]?['meta'];
              final price = meta?['regularMarketPrice'];
              final prevClose = meta?['previousClose'];
              if (price != null) {
                currentPrice = (price as num).toDouble() * multiplier;
                if (prevClose != null) {
                  final pc = (prevClose as num).toDouble() * multiplier;
                  currentChange =
                      pc != 0 ? ((currentPrice - pc) / pc) * 100 : 0.0;
                } else {
                  currentChange = 0.0;
                }
              }
            }
          } catch (_) {}
        }

        results.add(
          CommodityModel(
            name: name,
            unit: '/t',
            price: currentPrice,
            changePercent: double.parse(currentChange.toStringAsFixed(2)),
            sparkData: [currentPrice, ...prices],
            category: 'crop',
            forecastDetails: items,
          ),
        );
      }
      return results;
    } catch (e) {
      debugPrint('Error fetching commodities: $e');
      return [];
    }
  }
}
