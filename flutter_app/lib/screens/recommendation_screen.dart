import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({Key? key}) : super(key: key);
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<ProviderModel>> _providersFuture;

  @override
  void initState() {
    super.initState();
    _providersFuture = _apiService.fetchProviders();
  }

  String _serviceIcon(String service) {
    final s = service.toLowerCase();
    if (s.contains('ac') || s.contains('cool')) return '❄️';
    if (s.contains('plumb')) return '🔧';
    if (s.contains('elec')) return '⚡';
    if (s.contains('beauty') || s.contains('beautician')) return '💄';
    if (s.contains('tutor') || s.contains('teach')) return '📚';
    if (s.contains('paint')) return '🎨';
    return '🛠️';
  }

  Color _serviceColor(String service) {
    final s = service.toLowerCase();
    if (s.contains('ac') || s.contains('cool')) return const Color(0xFF29B6F6);
    if (s.contains('plumb')) return const Color(0xFF42A5F5);
    if (s.contains('elec')) return Colors.amber;
    if (s.contains('beauty')) return const Color(0xFFEC407A);
    if (s.contains('tutor')) return const Color(0xFF66BB6A);
    return AppTheme.emeraldGreen;
  }

  Widget _buildProviderCard(ProviderModel provider) {
    final color = _serviceColor(provider.service);
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header gradient
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Text(
                  _serviceIcon(provider.service),
                  style: const TextStyle(fontSize: 28),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.rating}',
                      style: GoogleFonts.inter(
                        color: AppTheme.textLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: GoogleFonts.outfit(
                    color: AppTheme.textLight,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    provider.service,
                    style: GoogleFonts.inter(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      LucideIcons.mapPin,
                      color: AppTheme.textMuted,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${provider.distance}km • ${provider.location}',
                        style: GoogleFonts.inter(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      LucideIcons.briefcase,
                      color: AppTheme.textMuted,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.experience} yrs exp',
                      style: GoogleFonts.inter(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    if (provider.priceRange != null &&
                        provider.priceRange!.isNotEmpty)
                      Text(
                        provider.priceRange!,
                        style: GoogleFonts.inter(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: provider.available
                        ? color.withOpacity(0.15)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: provider.available
                          ? color.withOpacity(0.4)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      provider.available ? '● Available Now' : '○ Busy',
                      style: GoogleFonts.inter(
                        color: provider.available ? color : AppTheme.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightBlue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.outfit(
                color: AppTheme.textLight,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeepBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDeepBlue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Providers',
          style: GoogleFonts.outfit(
            color: AppTheme.textLight,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.emeraldGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.emeraldGreen.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.emeraldGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Live DB',
                  style: GoogleFonts.inter(
                    color: AppTheme.emeraldGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<ProviderModel>>(
        future: _providersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.emeraldGreen),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.wifiOff,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Backend se connect nahi hua',
                    style: GoogleFonts.inter(color: AppTheme.textMuted),
                  ),
                ],
              ),
            );
          }
          final providers = snapshot.data ?? [];
          final available = providers.where((p) => p.available).length;

          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              // Stats row
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    _buildStatCard(
                      '${providers.length}',
                      'Total',
                      LucideIcons.users,
                      AppTheme.emeraldGreen,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      '$available',
                      'Available',
                      LucideIcons.checkCircle2,
                      const Color(0xFF00BFA5),
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      '${providers.isEmpty ? 0 : (providers.map((p) => p.rating).reduce((a, b) => a + b) / providers.length).toStringAsFixed(1)}',
                      'Avg ⭐',
                      LucideIcons.star,
                      Colors.amber,
                    ),
                  ],
                ),
              ),
              // Provider Cards
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 12),
                child: Text(
                  'All Providers',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textLight,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20, right: 6),
                  physics: const BouncingScrollPhysics(),
                  itemCount: providers.length,
                  itemBuilder: (context, index) =>
                      _buildProviderCard(providers[index]),
                ),
              ),
              const SizedBox(height: 24),
              // Emergency Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.redAccent.withOpacity(0.15),
                        Colors.red.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.alertTriangle,
                          color: Colors.redAccent,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emergency Service',
                              style: GoogleFonts.outfit(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '24/7 Plumber Available — Arrives in < 30 mins',
                              style: GoogleFonts.inter(
                                color: AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'SOS',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
