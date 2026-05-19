import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/api_models.dart';

class ApiService {
  // ─────────────────────────────────────────────
  // 🔧 CONFIGURATION — Edit these two lines only
  // ─────────────────────────────────────────────

  /// Set to your deployed backend URL (Railway / Render / Heroku / VPS / any)
  /// Leave as empty string '' to use local server instead
  static const String deployedUrl = 'https://service-sathi-production.up.railway.app/api';

  /// true  → use deployedUrl (production mode)
  /// false → use localhost (local development mode)
  static const bool useDeployed = true;

  // ─────────────────────────────────────────────
  // ⚙️  AUTO URL RESOLUTION — No need to edit below
  // ─────────────────────────────────────────────

  String get baseUrl {
    if (useDeployed && deployedUrl.isNotEmpty) {
      return deployedUrl;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    } else {
      return 'http://127.0.0.1:8000/api';
    }
  }

  // ─────────────────────────────────────────────
  // 🔑 AUTHENTICATION & TOKEN STORAGE
  // ─────────────────────────────────────────────

  static const String _tokenKey = 'auth_token';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  /// Check if the user is currently authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Get stored JWT token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get stored user name
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  /// Get stored user email
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  /// Helper to build authorized headers
  Future<Map<String, String>> _getHeaders() async {
    final headers = {'Content-Type': 'application/json'};
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ─────────────────────────────────────────────
  // 📡 AUTH API CALLS
  // ─────────────────────────────────────────────

  /// Register a new user account
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['detail'] ?? 'Registration failed';
      throw Exception(error);
    }
  }

  /// Log in and retrieve a session JWT token
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      final user = data['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userNameKey, user['name'] ?? '');
      await prefs.setString(_userEmailKey, user['email'] ?? '');
    } else {
      final error = jsonDecode(response.body)['detail'] ?? 'Login failed';
      throw Exception(error);
    }
  }

  /// Request a password reset OTP code via Gmail
  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['detail'] ?? 'Failed to send reset code';
      throw Exception(error);
    }
  }

  /// Verify OTP and reset password
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['detail'] ?? 'Password reset failed';
      throw Exception(error);
    }
  }

  /// Clear stored credentials and sign out
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }

  // ─────────────────────────────────────────────
  // 📡 APPLICATION API METHODS (JWT PROTECTED)
  // ─────────────────────────────────────────────

  Future<OrchestratorResponse> sendRequest(String text) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/request'),
      headers: headers,
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      return OrchestratorResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Session expired. Please log in again.');
    } else {
      throw Exception(
        'ServiceSathi API error (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<List<BookingConfirmation>> fetchBookings() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/bookings'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BookingConfirmation.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Session expired. Please log in again.');
    } else {
      throw Exception(
        'ServiceSathi API error (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<List<ProviderModel>> fetchProviders() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/providers'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProviderModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Session expired. Please log in again.');
    } else {
      throw Exception(
        'ServiceSathi API error (${response.statusCode}): ${response.body}',
      );
    }
  }
}
