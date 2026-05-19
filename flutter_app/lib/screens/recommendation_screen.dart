import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';
import 'agent_logs_screen.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<ProviderModel>> _providersFuture;
  String? _selectedCategory;
  bool _isBooking = false;

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

  void _bookAgent(ProviderModel provider) async {
    setState(() {
      _isBooking = true;
    });

    try {
      final bookingText = 'Book ${provider.name} for ${provider.service} in ${provider.location} immediately';
      final response = await _apiService.sendRequest(bookingText);
      
      if (!mounted) return;
      setState(() {
        _isBooking = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AgentLogsScreen(response: response),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isBooking = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _showProviderDetails(ProviderModel provider) {
    final color = _serviceColor(provider.service);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.85),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: color.withValues(alpha: 0.3)),
                        ),
                        child: Center(
                          child: Text(
                            _serviceIcon(provider.service),
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.name,
                              style: GoogleFonts.outfit(
                                color: AppTheme.textLight,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              provider.service,
                              style: GoogleFonts.inter(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Rating & Reviews',
                    style: GoogleFonts.outfit(
                      color: AppTheme.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            '${provider.rating}',
                            style: GoogleFonts.outfit(
                              color: AppTheme.textLight,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star_rounded,
                                color: i < provider.rating.floor()
                                    ? Colors.amber
                                    : Colors.white.withValues(alpha: 0.1),
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Based on 20+ bookings',
                            style: GoogleFonts.inter(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          children: [
                            _buildRatingBar(5, 0.85, color),
                            _buildRatingBar(4, 0.10, color),
                            _buildRatingBar(3, 0.03, color),
                            _buildRatingBar(2, 0.01, color),
                            _buildRatingBar(1, 0.01, color),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(LucideIcons.briefcase, '${provider.experience} yrs', 'Experience'),
                      _buildInfoItem(LucideIcons.wallet, provider.priceRange ?? r'$$', 'Price'),
                      _buildInfoItem(LucideIcons.mapPin, provider.location, 'Location'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.emeraldGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: AppTheme.emeraldGreen.withValues(alpha: 0.4),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _bookAgent(provider);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.calendarCheck, color: Colors.black, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Book Agent Now',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingBar(int star, double pct, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Row(
        children: [
          Text('$star', style: GoogleFonts.firaCode(color: AppTheme.textMuted, fontSize: 10)),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: pct,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.emeraldGreen, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              color: AppTheme.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppTheme.textMuted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredProviderRow(ProviderModel provider) {
    final color = _serviceColor(provider.service);
    return GestureDetector(
      onTap: () => _showProviderDetails(provider),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightBlue,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.25)),
              ),
              child: Center(
                child: Text(
                  _serviceIcon(provider.service),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: GoogleFonts.outfit(
                      color: AppTheme.textLight,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, color: AppTheme.textMuted, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${provider.location} • ${provider.distance}km',
                        style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
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
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: provider.available ? AppTheme.emeraldGreen.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    provider.available ? 'Available' : 'Busy',
                    style: GoogleFonts.inter(
                      color: provider.available ? AppTheme.emeraldGreen : AppTheme.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderCard(ProviderModel provider) {
    final color = _serviceColor(provider.service);
    return GestureDetector(
      onTap: () => _showProviderDetails(provider),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: AppTheme.lightBlue,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.02)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
                      color: color.withValues(alpha: 0.15),
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
                      const Icon(
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
                      const Icon(
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
                          ? color.withValues(alpha: 0.15)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: provider.available
                            ? color.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.2),
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
          border: Border.all(color: color.withValues(alpha: 0.25)),
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
    final categories = [
      {"name": "AC Technician", "label": "AC Repair", "icon": LucideIcons.snowflake, "color": const Color(0xFF29B6F6)},
      {"name": "Plumber", "label": "Plumbing", "icon": LucideIcons.wrench, "color": const Color(0xFF42A5F5)},
      {"name": "Electrician", "label": "Electrical", "icon": LucideIcons.zap, "color": Colors.amber},
      {"name": "Tutor", "label": "Tuition", "icon": LucideIcons.bookOpen, "color": const Color(0xFF66BB6A)},
      {"name": "Beautician", "label": "Beauty Care", "icon": LucideIcons.scissors, "color": const Color(0xFFEC407A)},
      {"name": "Painter", "label": "Painting", "icon": LucideIcons.paintbrush, "color": AppTheme.emeraldGreen},
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundDeepBlue,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          _selectedCategory == null ? 'Services' : _selectedCategory!,
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
              color: AppTheme.emeraldGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.emeraldGreen.withValues(alpha: 0.3)),
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
      body: Stack(
        children: [
          FutureBuilder<List<ProviderModel>>(
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

              final filteredProviders = _selectedCategory == null
                  ? providers
                  : providers
                      .where((p) =>
                          p.service.toLowerCase() ==
                          _selectedCategory!.toLowerCase())
                      .toList();

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 30),
                children: [
                  if (_selectedCategory == null) ...[
                    // Services Grid title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                      child: Text(
                        'All Services',
                        style: GoogleFonts.outfit(
                          color: AppTheme.textLight,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Grid of 6 services
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.3,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final color = cat["color"] as Color;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = cat["name"] as String),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.lightBlue,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: color.withValues(alpha: 0.2)),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(cat["icon"] as IconData, color: color, size: 24),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    cat["label"] as String,
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.textLight,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    // Filtered Title with Back Button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _selectedCategory = null),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.lightBlue,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                              ),
                              child: const Icon(LucideIcons.arrowLeft, color: AppTheme.textLight, size: 18),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Select an Agent',
                            style: GoogleFonts.outfit(
                              color: AppTheme.textLight,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Stats row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: Row(
                      children: [
                        _buildStatCard(
                          '${filteredProviders.length}',
                          'Total',
                          LucideIcons.users,
                          AppTheme.emeraldGreen,
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          '${filteredProviders.where((p) => p.available).length}',
                          'Available',
                          LucideIcons.checkCircle2,
                          const Color(0xFF00BFA5),
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          filteredProviders.isEmpty
                              ? '0'
                              : (filteredProviders.map((p) => p.rating).reduce((a, b) => a + b) / filteredProviders.length)
                                  .toStringAsFixed(1),
                          'Avg ⭐',
                          LucideIcons.star,
                          Colors.amber,
                        ),
                      ],
                    ),
                  ),

                  // Display providers list
                  if (_selectedCategory == null) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
                      child: Text(
                        'Featured Providers',
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
                        itemCount: providers.length > 10 ? 10 : providers.length,
                        itemBuilder: (context, index) =>
                            _buildProviderCard(providers[index]),
                      ),
                    ),
                  ] else ...[
                    // Filtered vertical list
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredProviders.length,
                        itemBuilder: (context, index) =>
                            _buildFilteredProviderRow(filteredProviders[index]),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Emergency Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.redAccent.withValues(alpha: 0.15),
                            Colors.red.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.15),
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
                ],
              );
            },
          ),
          if (_isBooking)
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        color: AppTheme.lightBlue,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.emeraldGreen.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.emeraldGreen.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: AppTheme.emeraldGreen),
                          const SizedBox(height: 20),
                          Text(
                            'AI Orchestrator Matching...',
                            style: GoogleFonts.outfit(
                              color: AppTheme.textLight,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Booking your agent and setting up the tracking pipeline...',
                            style: GoogleFonts.inter(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
