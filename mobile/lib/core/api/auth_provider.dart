import 'package:flutter/foundation.dart';

import 'api_client.dart';
import 'auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// ChangeNotifier that drives login/register/logout UI state.
///
/// Add to MultiProvider in main.dart:
///   ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? service}) : _service = service ?? authService;

  final AuthService _service;

  AuthStatus _status = AuthStatus.unknown;
  UserModel? _user;
  String?    _error;
  bool       _loading = false;

  AuthStatus  get status  => _status;
  UserModel?  get user    => _user;
  String?     get error   => _error;
  bool        get loading => _loading;
  bool        get isAuthenticated => _status == AuthStatus.authenticated;

  // ── Init ────────────────────────────────────────────────────────────────────

  Future<void> initialize() async {
    final loggedIn = await _service.isLoggedIn;
    if (loggedIn) {
      try {
        _user   = await _service.getProfile();
        _status = AuthStatus.authenticated;
      } catch (_) {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // ── Register ────────────────────────────────────────────────────────────────

  Future<bool> register({
    required String email,
    required String username,
    required String password,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    try {
      final result = await _service.register(
        email:       email,
        username:    username,
        password:    password,
        phoneNumber: phoneNumber,
      );
      _user   = result.user;
      _status = AuthStatus.authenticated;
      _error  = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Login ───────────────────────────────────────────────────────────────────

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final result = await _service.login(email: email, password: password);
      _user   = result.user;
      _status = AuthStatus.authenticated;
      _error  = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Logout ──────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _service.logout();
    } catch (_) {}
    _user   = null;
    _status = AuthStatus.unauthenticated;
    _error  = null;
    _setLoading(false);
  }

  // ── Profile ─────────────────────────────────────────────────────────────────

  Future<bool> updateProfile({String? username, String? phoneNumber}) async {
    _setLoading(true);
    try {
      _user  = await _service.updateProfile(
        username:    username,
        phoneNumber: phoneNumber,
      );
      _error = null;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
