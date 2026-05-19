import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        height: null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.emeraldGreen, size: 28),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.outfit(
                color: AppTheme.textLight,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String?>>(
      future: Future.wait([
        ApiService().getUserName(),
        ApiService().getUserEmail(),
      ]),
      builder: (context, snapshot) {
        final name = (snapshot.data?[0] != null && snapshot.data![0]!.isNotEmpty)
            ? snapshot.data![0]!
            : "User Profile";
        final email = (snapshot.data?[1] != null && snapshot.data![1]!.isNotEmpty)
            ? snapshot.data![1]!
            : "Not authenticated";

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.emeraldGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.emeraldGreenDark.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=0F0C29&color=fff&size=120',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        color: AppTheme.textLight,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: GoogleFonts.inter(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.05),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.crown, color: Colors.amber, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            "VIP Member",
                            style: GoogleFonts.inter(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        _buildStatCard("Total Bookings", "14", LucideIcons.calendarCheck),
                        const SizedBox(width: 16),
                        _buildStatCard("Saved", "Rs. 2500", LucideIcons.wallet),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GlassCard(
                      height: null,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(LucideIcons.settings, color: AppTheme.emeraldGreen, size: 20),
                            title: Text(
                              "Settings",
                              style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 14),
                            ),
                            trailing: const Icon(LucideIcons.chevronRight, color: AppTheme.textMuted, size: 16),
                          ),
                          const Divider(color: AppTheme.borderLight),
                          ListTile(
                            leading: const Icon(LucideIcons.creditCard, color: AppTheme.emeraldGreen, size: 20),
                            title: Text(
                              "Payment Methods",
                              style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 14),
                            ),
                            trailing: const Icon(LucideIcons.chevronRight, color: AppTheme.textMuted, size: 16),
                          ),
                          const Divider(color: AppTheme.borderLight),
                          ListTile(
                            leading: const Icon(LucideIcons.logOut, color: Colors.redAccent, size: 20),
                            title: Text(
                              "Logout",
                              style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            onTap: () async {
                              await ApiService().logout();
                              if (!context.mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
