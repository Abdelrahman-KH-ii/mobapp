import 'dart:convert';

import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/dashboard/data/models/dashboard_models.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/add_task_sheet.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/ai_reco_card.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/crop_lifecycle_card.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/dashboard_section_label.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/market_card.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/profit_calculator_card.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/soil_card.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/task_tile.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/weather_card.dart';
import 'package:farmtec/features/farm/presentation/providers/farm_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Map<String, dynamic>>> _pricesFuture;

  static const _soil = [
    SoilMetricModel(label: 'Nitrogen (N)', value: '68 ppm', progress: 0.68),
    SoilMetricModel(label: 'Phosphorus (P)', value: '45 ppm', progress: 0.45),
    SoilMetricModel(label: 'Potassium (K)', value: '82 ppm', progress: 0.82),
  ];

  bool _tasksInitialized = false;
  List<Map<String, dynamic>> _tasks = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_tasksInitialized) {
      final l = AppLocalizations.of(context);
      _tasks = [
        {
          'title': l.isArabic ? 'الري' : 'Irrigation',
          'schedule':
              l.isArabic ? 'يومياً • 06:00 صباحاً' : 'Daily • 06:00 AM',
        },
        {
          'title': l.isArabic ? 'تسميد (NPK)' : 'Fertilization (NPK)',
          'schedule': l.isArabic ? 'أسبوعياً • الإثنين' : 'Weekly • Monday',
        },
        {
          'title': l.isArabic ? 'رش المبيدات' : 'Pesticide Spraying',
          'schedule': l.isArabic ? 'مرة واحدة • غداً' : 'One-time • Tomorrow',
        },
      ];
      _tasksInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _pricesFuture = _fetchPrices();
  }

  Future<List<Map<String, dynamic>>> _fetchPrices() async {
    try {
      final r = await http
          .get(
            Uri.parse(
              'https://commodities-api.com/api/latest?access_key=DEMO&base=USD&symbols=WHEAT,CORN,RICE',
            ),
          )
          .timeout(const Duration(seconds: 4));
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body);
        if (data['data'] != null && data['data']['rates'] != null) {
          final rates = data['data']['rates'] as Map<String, dynamic>;
          return rates.entries.map((e) {
            return {
              'name': e.key,
              'price': '\$${(e.value as num).toStringAsFixed(2)}/t',
              'change': '+1.2%',
              'isUp': true,
              'rawValue': (e.value as num).toDouble(),
            };
          }).toList();
        }
      }
    } catch (_) {}

    try {
      final r = await http.get(
        Uri.parse('https://b1r-14n15-forecast.hf.space/forecast'),
      );
      if (r.statusCode == 200) {
        final List<dynamic> data = jsonDecode(r.body);
        final Map<String, List<double>> grouped = {};
        for (var item in data) {
          grouped
              .putIfAbsent(item['commodity'], () => [])
              .add((item['price'] as num).toDouble());
        }
        return grouped.entries.take(3).map((e) {
          final change = e.value.first != 0
              ? ((e.value.last - e.value.first) / e.value.first) * 100
              : 0.0;
          return {
            'name': e.key,
            'price': '\$${e.value.first.toStringAsFixed(2)}/t',
            'change': '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%',
            'isUp': change >= 0,
            'rawValue': e.value.first,
          };
        }).toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final farmService = Provider.of<FarmProvider>(context);
    final farm = farmService.selectedFarm;
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primary;
    final subColor = isDark ? Pallete.darkTextSecondary : Pallete.textSecondary;
    final cardColor = isDark ? Pallete.darkCard : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardHeader(
            farmName: farm?.name ?? l.tr('my_farm'),
            isDark: isDark,
            textColor: textColor,
            subColor: subColor,
          ),
          const SizedBox(height: 20),
          const WeatherCard(),
          const SizedBox(height: 20),
          DashboardSectionLabel(
            icon: Icons.eco_rounded,
            title: l.tr('crop_lifecycle'),
            color: textColor,
          ),
          const SizedBox(height: 10),
          CropLifecycleCard(
            isDark: isDark,
            cardColor: cardColor,
            textColor: textColor,
            subColor: subColor,
            crop: farm?.crop ?? 'Wheat',
            plantedAt: farm?.plantedAt,
          ),
          const SizedBox(height: 20),
          DashboardSectionLabel(
            icon: Icons.grass_rounded,
            title: l.tr('soil_metrics'),
            color: textColor,
          ),
          const SizedBox(height: 10),
          SoilCard(
            metrics: _soil,
            isDark: isDark,
            cardColor: cardColor,
            textColor: textColor,
          ),
          const SizedBox(height: 20),
          DashboardSectionLabel(
            icon: Icons.auto_awesome_rounded,
            title: l.tr('ai_recommendation'),
            color: textColor,
          ),
          const SizedBox(height: 10),
          AiRecoCard(
            isDark: isDark,
            textColor: textColor,
            farmName: farm?.name ?? 'Farm',
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DashboardSectionLabel(
                icon: Icons.task_alt_rounded,
                title: l.tr('task_automation'),
                color: textColor,
              ),
              GestureDetector(
                onTap: _showAddTaskSheet,
                child: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: Pallete.primary,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(_tasks.length, (index) {
            final task = _tasks[index];
            return TaskTile(
              title: task['title'],
              schedule: task['schedule'],
              initialCompleted: task['completed'] ?? false,
              isDark: isDark,
              cardColor: cardColor,
              textColor: textColor,
              subColor: subColor,
              onDelete: () {
                setState(() {
                  _tasks.removeAt(index);
                });
              },
            );
          }),
          const SizedBox(height: 20),
          DashboardSectionLabel(
            icon: Icons.show_chart_rounded,
            title: l.tr('market_snapshot'),
            color: textColor,
          ),
          const SizedBox(height: 10),
          MarketCard(
            future: _pricesFuture,
            isDark: isDark,
            cardColor: cardColor,
            textColor: textColor,
            subColor: subColor,
          ),
          const SizedBox(height: 20),
          DashboardSectionLabel(
            icon: Icons.calculate_rounded,
            title: l.tr('profit_calculator'),
            color: textColor,
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _pricesFuture,
            builder: (context, snapshot) {
              double price = 245.0;
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final List<Map<String, dynamic>> data = snapshot.data!;
                Map<String, dynamic>? match;
                final cropName = (farm?.crop ?? 'wheat').toLowerCase();
                for (final m in data) {
                  if (m['name'].toString().toLowerCase().contains(cropName)) {
                    match = m;
                    break;
                  }
                }
                match ??= data.first;
                if (match['rawValue'] != null) {
                  price = (match['rawValue'] as num).toDouble();
                }
              }

              return ProfitCalculatorCard(
                isDark: isDark,
                cardColor: cardColor,
                textColor: textColor,
                subColor: subColor,
                marketPrice: price,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddTaskSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTaskSheet(
        onAdd: (title) {
          setState(() {
            _tasks.add({'title': title, 'schedule': 'One-time • Today'});
          });
        },
      ),
    );
  }
}
