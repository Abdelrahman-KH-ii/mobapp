import 'dart:convert';

import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/services/farm_history_service.dart';
import 'package:farmtec/core/services/yield_prediction_service.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/ai_models/presentation/widgets/ai_model_definition.dart';
import 'package:farmtec/features/farm/presentation/providers/farm_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AiModelRunScreen extends StatefulWidget {
  final AIModelDefinition model;

  const AiModelRunScreen({super.key, required this.model});

  @override
  State<AiModelRunScreen> createState() => _AiModelRunScreenState();
}

class _AiModelRunScreenState extends State<AiModelRunScreen> {
  late Map<String, TextEditingController> _controllers;
  bool _loading = false;
  String? _result;
  bool _isError = false;

  static const _descs = {
    'Crop Recommendation':
        'Analyzes soil composition, weather patterns, and climate data to recommend the most profitable crop for your field conditions.',
    'Yield Prediction':
        'Combines satellite imagery, weather forecasts, and historical data to forecast expected harvest with high accuracy.',
    'Irrigation Planner':
        'Calculates optimal irrigation from soil moisture, evapotranspiration, and precipitation forecasts.',
    'Market Forecast':
        'Commodity price forecasting from live market data to time your sales for maximum profit.',
  };

  static const _stats = {
    'Crop Recommendation': {'Accuracy': '94%', 'Speed': '1.2s', 'Runs': '2.4K'},
    'Yield Prediction': {'Accuracy': '92%', 'Speed': '1.5s', 'Runs': '5.6K'},
    'Irrigation Planner': {'Accuracy': '93%', 'Speed': '1.8s', 'Runs': '3.2K'},
    'Market Forecast': {'Accuracy': '89%', 'Speed': '0.6s', 'Runs': '12K'},
  };

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final f in widget.model.fields) f.key: TextEditingController(),
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final farm = Provider.of<FarmProvider>(context, listen: false).selectedFarm;
      if (farm != null) {
        if (farm.lat != 0 && _controllers.containsKey('lat')) {
          _controllers['lat']!.text = farm.lat.toStringAsFixed(4);
        }
        if (farm.lng != 0 && _controllers.containsKey('lon')) {
          _controllers['lon']!.text = farm.lng.toStringAsFixed(4);
        }
        if (_controllers.containsKey('crop') && farm.crop.isNotEmpty) {
          _controllers['crop']!.text = farm.crop;
        }
        if (_controllers.containsKey('year')) {
          _controllers['year']!.text = DateTime.now().year.toString();
        }
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _runPrediction() async {
    setState(() {
      _loading = true;
      _result = null;
      _isError = false;
    });
    try {
      http.Response response;
      if (widget.model.name == 'Market Forecast') {
        response = await http
            .get(Uri.parse(widget.model.apiUrl))
            .timeout(const Duration(seconds: 15));
      } else if (widget.model.name == 'Irrigation Planner') {
        final body = <String, dynamic>{};
        for (final f in widget.model.fields) {
          final val = _controllers[f.key]!.text.isNotEmpty
              ? _controllers[f.key]!.text
              : f.hint;
          body[f.key] = double.tryParse(val) ?? val;
        }
        response = await http
            .post(
              Uri.parse(widget.model.apiUrl),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'data': body}),
            )
            .timeout(const Duration(seconds: 15));
      } else {
        final body = <String, dynamic>{};
        for (final f in widget.model.fields) {
          final val = _controllers[f.key]!.text.isNotEmpty
              ? _controllers[f.key]!.text
              : f.hint;
          if (f.key == 'year') {
            body[f.key] = int.tryParse(val) ?? val;
          } else if (f.type == TextInputType.number ||
              f.type ==
                  const TextInputType.numberWithOptions(decimal: true)) {
            body[f.key] = double.tryParse(val) ?? val;
          } else {
            body[f.key] = val;
          }
        }
        response = await http
            .post(
              Uri.parse(widget.model.apiUrl),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 15));
      }
      if (!mounted) return;
      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        _result = _fmt(decoded);
        if (mounted) await _persistResult(decoded);
      } else {
        _isError = true;
        final l = AppLocalizations.of(context);
        _result = l.trParams(
          'api_error',
          {'code': response.statusCode.toString()},
        );
      }
    } catch (_) {
      if (!mounted) return;
      _isError = true;
      _result = AppLocalizations.of(context).tr('connection_error');
    }
    if (mounted) setState(() => _loading = false);
  }

  String? _titleKeyForModel(String name) {
    switch (name) {
      case 'Crop Recommendation':
        return 'op_ai_crop_recommendation';
      case 'Yield Prediction':
        return 'op_ai_yield_prediction';
      case 'Irrigation Planner':
        return 'op_ai_irrigation_planner';
      case 'Market Forecast':
        return 'op_ai_market_forecast';
      default:
        return null;
    }
  }

  OperationType _typeForModel(String name) {
    switch (name) {
      case 'Irrigation Planner':
        return OperationType.irrigation;
      case 'Crop Recommendation':
        return OperationType.cropPlant;
      default:
        return OperationType.aiModelRun;
    }
  }

  Future<void> _persistResult(dynamic decoded) async {
    final farm = Provider.of<FarmProvider>(context, listen: false).selectedFarm;
    final summary = _result ?? decoded.toString();

    if (farm != null) {
      await Provider.of<FarmHistoryService>(context, listen: false).addOperation(
        FarmOperation(
          id: 'op_${DateTime.now().microsecondsSinceEpoch}',
          farmId: farm.id,
          type: _typeForModel(widget.model.name),
          title: widget.model.name,
          titleKey: _titleKeyForModel(widget.model.name),
          description: summary,
          timestamp: DateTime.now(),
        ),
      );
    }

    if (widget.model.name == 'Yield Prediction' && decoded is Map) {
      final y = decoded['predicted_yield'] ?? decoded['yield'] ?? decoded['prediction'];
      if (y != null) {
        final yieldVal = y is num ? y.toDouble() : double.tryParse(y.toString());
        if (yieldVal != null) {
          final crop =
              _controllers['crop']?.text.trim().isNotEmpty == true
                  ? _controllers['crop']!.text.trim()
                  : (farm?.crop ?? 'Wheat');
          await Provider.of<YieldPredictionService>(
            context,
            listen: false,
          ).updatePrediction(
            yieldPerHa: yieldVal,
            crop: crop,
            field: farm?.name ?? crop,
            unit: (decoded['unit'] ?? 't/ha').toString(),
          );
        }
      }
    }
  }

  String _fmt(dynamic d) {
    switch (widget.model.name) {
      case 'Crop Recommendation':
        final c =
            (d['predicted_crop'] ?? d['prediction'] ?? 'Unknown').toString();
        return '🌾 Recommended: ${c.isNotEmpty ? c[0].toUpperCase() + c.substring(1) : c}';
      case 'Yield Prediction':
        final y = d['predicted_yield'] ?? d['yield'] ?? d['prediction'];
        return y != null
            ? '📊 Yield: ${(y is num ? y.toStringAsFixed(2) : y)} ${d['unit'] ?? 't/ha'}'
            : '📊 $d';
      case 'Irrigation Planner':
        return '💧 Need: ${d['irrigation_need_mm'] ?? 'N/A'}mm (${d['irrigation_class'] ?? 'N/A'})';
      case 'Market Forecast':
        if (d is List && d.isNotEmpty) {
          return '📈 Forecast:\n${d.take(5).map((e) => '  • ${e['commodity']}: \$${(e['price'] as num).toStringAsFixed(2)}/t').join('\n')}';
        }
        return '📈 $d';
      default:
        return d.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Pallete.darkBackground : Pallete.background;
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primary;
    final subColor = isDark ? Pallete.darkTextSecondary : Pallete.textSecondary;
    final fillColor = isDark ? Pallete.darkSurfaceVariant : Pallete.background;
    final cardColor = isDark ? Pallete.darkCard : Colors.white;
    final desc = _descs[widget.model.name] ?? widget.model.desc;
    final stats =
        _stats[widget.model.name] ?? {'Accuracy': '90%', 'Speed': '1s', 'Runs': '1K'};

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: widget.model.color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.model.color,
                      widget.model.color.withAlpha(180),
                      bgColor,
                    ],
                    stops: const [0.0, 0.65, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(35),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(50),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.model.icon,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        l.tr(
                          widget.model.name.toLowerCase().replaceAll(' ', '_'),
                        ),
                        style: GoogleFonts.manrope(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'FarmBrain ML · HuggingFace',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 25 : 8),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: stats.entries
                          .map(
                            (e) => Column(
                              children: [
                                Text(
                                  e.value,
                                  style: GoogleFonts.manrope(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: widget.model.color,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  e.key,
                                  style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    color: subColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l.tr('about'),
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: subColor,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (widget.model.fields.isNotEmpty) ...[
                    Text(
                      l.tr('input_parameters'),
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.tr('auto_filled_gps'),
                      style: GoogleFonts.manrope(fontSize: 12, color: subColor),
                    ),
                    const SizedBox(height: 14),
                    ...widget.model.fields.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          controller: _controllers[f.key],
                          keyboardType: f.type,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: textColor,
                          ),
                          decoration: InputDecoration(
                            labelText: f.label == 'Latitude'
                                ? l.tr('latitude')
                                : f.label == 'Longitude'
                                    ? l.tr('longitude')
                                    : f.label == 'Year'
                                        ? l.tr('year')
                                        : f.label == 'Crop'
                                            ? l.tr('crop_type')
                                            : f.label,
                            hintText: f.hint,
                            labelStyle: GoogleFonts.manrope(
                              fontSize: 13,
                              color: subColor,
                            ),
                            hintStyle: GoogleFonts.manrope(
                              fontSize: 13,
                              color: isDark
                                  ? Pallete.darkTextTertiary
                                  : Pallete.textHint,
                            ),
                            filled: true,
                            fillColor: fillColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: widget.model.color,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.model.color,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            widget.model.color.withAlpha(100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      icon: _loading
                          ? const SizedBox.shrink()
                          : const Icon(Icons.play_arrow_rounded, size: 22),
                      onPressed: _loading ? null : _runPrediction,
                      label: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              l.tr('run_prediction'),
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  if (_result != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isError
                              ? Pallete.error.withAlpha(60)
                              : widget.model.color.withAlpha(60),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isError
                                    ? Pallete.error
                                    : widget.model.color)
                                .withAlpha(15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isError
                                    ? Icons.warning_amber_rounded
                                    : Icons.insights_rounded,
                                color: _isError
                                    ? Pallete.error
                                    : widget.model.color,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isError ? l.tr('error') : l.tr('prediction_results'),
                                style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _result!,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: textColor,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
