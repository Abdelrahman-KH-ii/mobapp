import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/services/weather_service.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/weather_forecast_day.dart';
import 'package:farmtec/features/dashboard/presentation/widgets/weather_stat.dart';
import 'package:farmtec/features/farm/presentation/providers/farm_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  Future<WeatherData?>? _weatherFuture;
  bool _showForecast = false;
  String? _lastFarmId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final farm = Provider.of<FarmProvider>(context, listen: true).selectedFarm;
    if (farm?.id != _lastFarmId || _weatherFuture == null) {
      _lastFarmId = farm?.id;
      final lat = farm?.lat ?? 30.0444;
      final lng = farm?.lng ?? 31.2357;
      _weatherFuture = WeatherService.fetchWeather(lat, lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return FutureBuilder<WeatherData?>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white70,
                strokeWidth: 2,
              ),
            ),
          );
        }

        final weather = snapshot.data;
        if (weather == null) return _buildFallbackCard(l);

        final emoji = WeatherService.getEmoji(weather.weatherCode);
        final desc = l.isArabic
            ? WeatherService.getDescriptionAr(weather.weatherCode)
            : weather.description;
        final isOptimal = weather.temperature >= 15 &&
            weather.temperature <= 35 &&
            weather.humidity >= 40 &&
            weather.humidity <= 85;

        return GestureDetector(
          onTap: () => setState(() => _showForecast = !_showForecast),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B4332).withAlpha(90),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.convertNumbers(
                              '${weather.temperature.round()}°C',
                            ),
                            style: GoogleFonts.manrope(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            desc,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isOptimal
                              ? l.tr('optimal')
                              : (l.isArabic ? 'تنبيه' : 'Alert'),
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isOptimal
                                ? const Color(0xFF86EFAC)
                                : const Color(0xFFFCA5A5),
                            letterSpacing: 0.8,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(38),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isOptimal
                                ? l.tr('for_growth')
                                : (l.isArabic ? 'راقب المزرعة' : 'MONITOR'),
                            style: GoogleFonts.manrope(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: WeatherStat(
                        Icons.water_drop_rounded,
                        '${weather.humidity}%',
                        l.tr('humidity'),
                      ),
                    ),
                    Expanded(
                      child: WeatherStat(
                        Icons.grain_rounded,
                        '${weather.precipitation}mm',
                        l.tr('precipitation'),
                      ),
                    ),
                    Expanded(
                      child: WeatherStat(
                        Icons.air_rounded,
                        '${weather.windSpeed.round()} km/h',
                        l.tr('wind'),
                      ),
                    ),
                    Expanded(
                      child: WeatherStat(
                        Icons.thermostat_rounded,
                        '${(weather.temperature - 5).round()}°C',
                        l.tr('soil_temp'),
                      ),
                    ),
                  ],
                ),
                if (_showForecast && weather.forecast.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 12),
                  Text(
                    l.isArabic ? 'توقعات الأيام القادمة' : '5-Day Forecast',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white60,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weather.forecast.map((day) {
                      return Expanded(
                        child: WeatherForecastDay(
                          day: _getDayName(day.date, l.isArabic),
                          emoji: WeatherService.getEmoji(day.weatherCode),
                          high: '${day.maxTemp.round()}°',
                          low: '${day.minTemp.round()}°',
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackCard(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded, color: Colors.white54, size: 32),
          const SizedBox(width: 12),
          Text(
            l.isArabic ? 'تعذّر تحميل الطقس' : 'Weather unavailable',
            style: GoogleFonts.manrope(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date, bool isArabic) {
    final now = DateTime.now();
    if (date.day == now.day) return isArabic ? 'اليوم' : 'Today';
    const en = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const ar = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return isArabic ? ar[date.weekday - 1] : en[date.weekday - 1];
  }
}
