import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_constants.dart';

// ── Token storage keys ────────────────────────────────────────────────────────
const _kAccessToken  = 'api_access_token';
const _kRefreshToken = 'api_refresh_token';

/// Low-level HTTP client for the FarmTech Mobile API.
///
/// • Attaches JWT Bearer token automatically.
/// • Silently refreshes the access token when a 401 is received.
/// • Throws [ApiException] on non-2xx responses.
class ApiClient {
  ApiClient({http.Client? httpClient})
      : _http = httpClient ?? http.Client();

  final http.Client _http;

  static const Duration _timeout = Duration(seconds: 30);

  // ── Token management ────────────────────────────────────────────────────────

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAccessToken);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRefreshToken);
  }

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccessToken, access);
    await prefs.setString(_kRefreshToken, refresh);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccessToken);
    await prefs.remove(_kRefreshToken);
  }

  Future<bool> get isLoggedIn async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ── Token refresh ────────────────────────────────────────────────────────────

  Future<bool> _tryRefresh() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return false;

    try {
      final response = await _http
          .post(
            Uri.parse(ApiConstants.tokenRefresh),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh': refresh}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccess  = data['access']  as String?;
        final newRefresh = data['refresh'] as String? ?? refresh;
        if (newAccess != null) {
          await saveTokens(access: newAccess, refresh: newRefresh);
          return true;
        }
      }
    } catch (_) {}
    return false;
  }

  // ── Headers ──────────────────────────────────────────────────────────────────

  Future<Map<String, String>> _authHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Core request ─────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _request(
    String method,
    String url, {
    Map<String, dynamic>? body,
    bool retry = true,
  }) async {
    final headers = await _authHeaders();
    final uri     = Uri.parse(url);

    http.Response response;

    try {
      response = await _send(method, uri, headers, body).timeout(_timeout);
    } on SocketException {
      throw const ApiException('No internet connection. Check your network.');
    } on HttpException {
      throw const ApiException('Server unreachable. Try again later.');
    }

    // 401 → try refresh once
    if (response.statusCode == 401 && retry) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        return _request(method, url, body: body, retry: false);
      }
      await clearTokens(); // session expired
      throw const ApiException('Session expired. Please login again.', code: 401);
    }

    return _parse(response);
  }

  Future<http.Response> _send(
    String method,
    Uri uri,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) {
    final encoded = body != null ? jsonEncode(body) : null;
    switch (method) {
      case 'GET':
        return _http.get(uri, headers: headers);
      case 'POST':
        return _http.post(uri, headers: headers, body: encoded);
      case 'PUT':
        return _http.put(uri, headers: headers, body: encoded);
      case 'PATCH':
        return _http.patch(uri, headers: headers, body: encoded);
      case 'DELETE':
        return _http.delete(uri, headers: headers);
      default:
        throw UnsupportedError('Unsupported HTTP method: $method');
    }
  }

  Map<String, dynamic> _parse(http.Response response) {
    Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      data = {'raw': response.body};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    // Extract error message from our API's { "success": false, "error": "..." }
    final error = data['error'] ?? data['detail'] ?? 'Request failed (${response.statusCode})';
    throw ApiException(error.toString(), code: response.statusCode);
  }

  // ── Public HTTP methods ────────────────────────────────────────────────────

  Future<Map<String, dynamic>> get(String url)                       => _request('GET',    url);
  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body) => _request('POST',   url, body: body);
  Future<Map<String, dynamic>> put(String url, Map<String, dynamic> body)  => _request('PUT',    url, body: body);
  Future<Map<String, dynamic>> patch(String url, Map<String, dynamic> body)=> _request('PATCH',  url, body: body);
  Future<Map<String, dynamic>> delete(String url)                    => _request('DELETE', url);

  /// Multipart upload for image files (plant disease detection).
  Future<Map<String, dynamic>> uploadImage(
    String url,
    File imageFile, {
    String fieldName = 'image',
  }) async {
    final token   = await getAccessToken();
    final request = http.MultipartRequest('POST', Uri.parse(url));

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(
      await http.MultipartFile.fromPath(fieldName, imageFile.path),
    );

    final streamed  = await request.send().timeout(_timeout);
    final response  = await http.Response.fromStream(streamed);
    return _parse(response);
  }

  void dispose() => _http.close();
}

// ── Exception ─────────────────────────────────────────────────────────────────

class ApiException implements Exception {
  const ApiException(this.message, {this.code});
  final String message;
  final int? code;

  bool get isUnauthorized => code == 401;
  bool get isNotFound     => code == 404;
  bool get isServerError  => code != null && code! >= 500;

  @override
  String toString() => message;
}

// ── Singleton ─────────────────────────────────────────────────────────────────

/// Global singleton – use this everywhere in the app.
final apiClient = ApiClient();
