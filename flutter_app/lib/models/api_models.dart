class IntentOutput {
  final String serviceType;
  final String location;
  final String time;
  final String language;

  IntentOutput({
    required this.serviceType,
    required this.location,
    required this.time,
    required this.language,
  });

  factory IntentOutput.fromJson(Map<String, dynamic> json) {
    return IntentOutput(
      serviceType: json['service_type']?.toString() ?? 'Unknown',
      location: json['location']?.toString() ?? 'Unknown',
      time: json['time']?.toString() ?? 'Unknown',
      language: json['language']?.toString() ?? 'Unknown',
    );
  }
}

class ProviderModel {
  final int id;
  final String name;
  final String service;
  final String location;
  final double lat;
  final double lng;
  final double rating;
  final double distance;
  final bool available;
  final int experience;
  final String? phone;
  final String? priceRange;

  ProviderModel({
    required this.id,
    required this.name,
    required this.service,
    required this.location,
    required this.lat,
    required this.lng,
    required this.rating,
    required this.distance,
    required this.available,
    required this.experience,
    this.phone,
    this.priceRange,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      service: json['service']?.toString() ?? json['service_category']?.toString() ?? '',
      location: json['location']?.toString() ?? json['area']?.toString() ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      available: json['available'] ?? false,
      experience: json['experience'] ?? 0,
      phone: json['phone']?.toString(),
      priceRange: json['price_range']?.toString(),
    );
  }
}

class BookingConfirmation {
  final int bookingId;
  final String providerName;
  final String scheduledTime;
  final String status;

  BookingConfirmation({
    required this.bookingId,
    required this.providerName,
    required this.scheduledTime,
    required this.status,
  });

  factory BookingConfirmation.fromJson(Map<String, dynamic> json) {
    return BookingConfirmation(
      bookingId: json['booking_id'] ?? 0,
      providerName: json['provider_name']?.toString() ?? 'Unknown',
      scheduledTime: json['scheduled_time']?.toString() ?? 'Not Scheduled',
      status: json['status']?.toString() ?? 'Confirmed',
    );
  }
}

class OrchestratorResponse {
  final IntentOutput intent;
  final ProviderModel? recommendedProvider;
  final String reasoning;
  final BookingConfirmation? booking;
  final List<String> followUpSchedule;
  final List<Map<String, dynamic>> agentTrace;

  OrchestratorResponse({
    required this.intent,
    this.recommendedProvider,
    required this.reasoning,
    this.booking,
    required this.followUpSchedule,
    required this.agentTrace,
  });

  factory OrchestratorResponse.fromJson(Map<String, dynamic> json) {
    return OrchestratorResponse(
      intent: IntentOutput.fromJson(json['intent'] ?? {}),
      recommendedProvider: json['recommended_provider'] != null
          ? ProviderModel.fromJson(json['recommended_provider'])
          : null,
      reasoning: json['reasoning']?.toString() ?? '',
      booking: json['booking'] != null
          ? BookingConfirmation.fromJson(json['booking'])
          : null,
      followUpSchedule: List<String>.from(json['follow_up_schedule'] ?? []),
      agentTrace: List<Map<String, dynamic>>.from(json['agent_trace'] ?? []),
    );
  }
}
