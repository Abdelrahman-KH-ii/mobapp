/// FarmTech Mobile API – base URL and endpoint constants.
///
/// To change the server, only edit [baseUrl] here.
abstract final class ApiConstants {
  // ── Change this to your production server ──────────────────────────────────
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/mobile', // Android emulator → localhost
    // Use 'http://localhost:8000/api/mobile' for iOS simulator
    // Use 'http://<YOUR_SERVER_IP>/api/mobile' for real device / production
  );

  // ── Auth ───────────────────────────────────────────────────────────────────
  static const String register       = '$baseUrl/auth/register/';
  static const String login          = '$baseUrl/auth/login/';
  static const String logout         = '$baseUrl/auth/logout/';
  static const String profile        = '$baseUrl/auth/profile/';
  static const String changePassword = '$baseUrl/auth/change-password/';
  static const String tokenRefresh   = '$baseUrl/auth/token/refresh/';

  // ── Dashboard ──────────────────────────────────────────────────────────────
  static const String dashboard = '$baseUrl/dashboard/';

  // ── Farms ──────────────────────────────────────────────────────────────────
  static const String farms = '$baseUrl/farms/';
  static String farmDetail(int id)      => '$baseUrl/farms/$id/';
  static String farmSensorData(int id)  => '$baseUrl/farms/$id/sensor-data/';
  static String farmPlots(int id)       => '$baseUrl/farms/$id/plots/';

  // ── Plots ──────────────────────────────────────────────────────────────────
  static String plotDetail(int id)      => '$baseUrl/plots/$id/';
  static String plotSoil(int id)        => '$baseUrl/plots/$id/soil/';
  static String plotIrrigation(int id)  => '$baseUrl/plots/$id/irrigation/';

  // ── Crop Fields ────────────────────────────────────────────────────────────
  static const String cropFields = '$baseUrl/crop-fields/';
  static String cropFieldDetail(int id) => '$baseUrl/crop-fields/$id/';

  // ── AI ─────────────────────────────────────────────────────────────────────
  static const String aiPlantDisease       = '$baseUrl/ai/plant-disease/';
  static const String aiCropRecommendation = '$baseUrl/ai/crop-recommendation/';
  static const String aiIrrigation         = '$baseUrl/ai/irrigation/';
  static const String aiYield              = '$baseUrl/ai/yield/';
  static const String aiForecast           = '$baseUrl/ai/forecast/';
  static const String aiHistory            = '$baseUrl/ai/history/';

  // ── News ───────────────────────────────────────────────────────────────────
  static const String news           = '$baseUrl/news/';
  static const String newsCategories = '$baseUrl/news/categories/';
  static String newsDetail(int id)   => '$baseUrl/news/$id/';
  static String newsComments(int id) => '$baseUrl/news/$id/comments/';

  // ── Health ─────────────────────────────────────────────────────────────────
  static const String health = '$baseUrl/health/';
}
