import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../services/api_service.dart';
import '../models/api_models.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  late Future<List<BookingConfirmation>> _bookingsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  void _fetchBookings() {
    setState(() {
      _bookingsFuture = _apiService.fetchBookings();
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return AppTheme.emeraldGreen;
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  Widget _buildBookingItem(BookingConfirmation booking) {
    final statusColor = _getStatusColor(booking.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GlassCard(
        height: null,
        borderColor: statusColor.withValues(alpha: 0.25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Service Booking",
                  style: GoogleFonts.outfit(
                    color: AppTheme.textLight,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(LucideIcons.user, color: AppTheme.textMuted, size: 16),
                const SizedBox(width: 8),
                Text(
                  booking.providerName,
                  style: GoogleFonts.inter(
                    color: AppTheme.textLight.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(LucideIcons.calendar, color: AppTheme.textMuted, size: 16),
                const SizedBox(width: 8),
                Text(
                  booking.scheduledTime,
                  style: GoogleFonts.inter(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Bookings",
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: IconButton(
                      icon: const Icon(LucideIcons.refreshCw, color: AppTheme.emeraldGreen, size: 20),
                      onPressed: _fetchBookings,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: FutureBuilder<List<BookingConfirmation>>(
                  future: _bookingsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppTheme.emeraldGreen));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Failed to load bookings:\n${snapshot.error}",
                          style: GoogleFonts.inter(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No bookings found in database.",
                          style: GoogleFonts.inter(color: AppTheme.textMuted),
                        ),
                      );
                    }

                    final bookings = snapshot.data!;
                    
                    // Add 2 fake completed bookings for the demo if not already added
                    if (!bookings.any((b) => b.bookingId == 9991)) {
                      bookings.add(BookingConfirmation(
                        bookingId: 9991,
                        providerName: "Hassan Plumbers",
                        scheduledTime: "10 May, 2:00 PM",
                        status: "Completed",
                      ));
                    }
                    if (!bookings.any((b) => b.bookingId == 9992)) {
                      bookings.add(BookingConfirmation(
                        bookingId: 9992,
                        providerName: "Sana Beautician",
                        scheduledTime: "05 May, 10:00 AM",
                        status: "Completed",
                      ));
                    }

                    // Sort bookings with newest first (assuming higher ID = newer)
                    bookings.sort((a, b) => b.bookingId.compareTo(a.bookingId));

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        return _buildBookingItem(bookings[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
