import 'api_client.dart';
import 'api_constants.dart';

/// Result returned after login or register.
class AuthResult {
  const AuthResult({
    required this.access,
    required this.refresh,
    required this.user,
  });

  final String access;
  final String refresh;
  final UserModel user;

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        access:  json['access']  as String,
        refresh: json['refresh'] as String,
        user:    UserModel.fromJson(json['user'] as Map<String, dynamic>),
      );
}

class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.dateJoined,
  });

  final int    id;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? dateJoined;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id:          json['id'] as int? ?? 0,
        email:       json['email']    as String,
        username:    json['username'] as String,
        phoneNumber: json['phone_number'] as String?,
        dateJoined:  json['date_joined']  as String?,
      );

  Map<String, dynamic> toJson() => {
        'id':           id,
        'email':        email,
        'username':     username,
        'phone_number': phoneNumber,
        'date_joined':  dateJoined,
      };

  UserModel copyWith({String? username, String? phoneNumber}) => UserModel(
        id:          id,
        email:       email,
        username:    username    ?? this.username,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        dateJoined:  dateJoined,
      );
}

/// Handles all authentication API calls.
class AuthService {
  AuthService({ApiClient? client}) : _client = client ?? apiClient;

  final ApiClient _client;

  /// Register a new account.
  Future<AuthResult> register({
    required String email,
    required String username,
    required String password,
    String? phoneNumber,
  }) async {
    final body = <String, dynamic>{
      'email':    email,
      'username': username,
      'password': password,
      if (phoneNumber != null && phoneNumber.isNotEmpty)
        'phone_number': phoneNumber,
    };
    final data = await _client.post(ApiConstants.register, body);
    final result = AuthResult.fromJson(data);
    await _client.saveTokens(access: result.access, refresh: result.refresh);
    return result;
  }

  /// Login with email + password.
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final data = await _client.post(ApiConstants.login, {
      'email':    email,
      'password': password,
    });
    final result = AuthResult.fromJson(data);
    await _client.saveTokens(access: result.access, refresh: result.refresh);
    return result;
  }

  /// Logout and blacklist the refresh token.
  Future<void> logout() async {
    final refresh = await _client.getRefreshToken();
    if (refresh != null) {
      try {
        await _client.post(ApiConstants.logout, {'refresh': refresh});
      } catch (_) {
        // Even if the server call fails, clear local tokens
      }
    }
    await _client.clearTokens();
  }

  /// Get current user profile.
  Future<UserModel> getProfile() async {
    final data = await _client.get(ApiConstants.profile);
    return UserModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// Update username and/or phone number.
  Future<UserModel> updateProfile({
    String? username,
    String? phoneNumber,
  }) async {
    final body = <String, dynamic>{
      if (username    != null) 'username':     username,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    };
    final data = await _client.put(ApiConstants.profile, body);
    return UserModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// Change password.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _client.post(ApiConstants.changePassword, {
      'old_password': oldPassword,
      'new_password': newPassword,
    });
    // New tokens will be required after password change – clear locally
    await _client.clearTokens();
  }

  /// True if there is a saved access token.
  Future<bool> get isLoggedIn => _client.isLoggedIn;
}

/// Global singleton.
final authService = AuthService();
