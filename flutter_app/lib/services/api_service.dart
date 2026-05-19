import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
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
    // Use deployed URL if configured and enabled
    if (useDeployed && deployedUrl.isNotEmpty) {
      return deployedUrl;
    }

    // Local development fallbacks
    if (kIsWeb) {
      // Browser
      return 'http://127.0.0.1:8000/api';
    } else if (Platform.isAndroid) {
      // Android emulator: 10.0.2.2 maps to your PC's localhost
      return 'http://10.0.2.2:8000/api';
    } else {
      // iOS simulator / desktop
      return 'http://127.0.0.1:8000/api';
    }
  }

  // ─────────────────────────────────────────────
  // 📡 API METHODS
  // ─────────────────────────────────────────────

  Future<OrchestratorResponse> sendRequest(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      return OrchestratorResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'ServiceSathi API error (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<List<BookingConfirmation>> fetchBookings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BookingConfirmation.fromJson(json)).toList();
    } else {
      throw Exception(
        'ServiceSathi API error (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<List<ProviderModel>> fetchProviders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/providers'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProviderModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'ServiceSathi API error (${response.statusCode}): ${response.body}',
      );
    }
  }
}
