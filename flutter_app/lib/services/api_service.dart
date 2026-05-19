import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/api_models.dart';

class ApiService {
  // 🚀 PASTE YOUR RAILWAY DEPLOYMENT LINK HERE:
  // Example: 'https://service-sathi-production.up.railway.app/api'
  static const String railwayUrl =
      'https://service-sathi-production.up.railway.app/api';

  // Set this to true when you want to use the Railway URL instead of local
  static const bool useRailway = true;

  String get baseUrl {
    if (useRailway && railwayUrl != 'PASTE_RAILWAY_URL_HERE/api') {
      return railwayUrl;
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    } else if (Platform.isAndroid) {
      // Your computer's local Wi-Fi IP address
      return 'http://192.168.10.14:8000/api';
    } else {
      return 'http://127.0.0.1:8000/api';
    }
  }

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
        'Failed to communicate with Antigravity Orchestrator: ${response.body}',
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
      throw Exception('Failed to fetch bookings: ${response.body}');
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
      throw Exception('Failed to fetch providers: ${response.body}');
    }
  }
}
