/// Agromonitoring (OpenWeather Agro API) key for Sentinel-2 NDVI.
///
/// Override with `--dart-define=AGROMONITORING_API_KEY=other_key` if needed.
abstract final class AgromonitoringConfig {
  static const String apiKey = String.fromEnvironment(
    'AGROMONITORING_API_KEY',
    defaultValue: '',
  );
  static bool get isConfigured => apiKey.isNotEmpty;
}
