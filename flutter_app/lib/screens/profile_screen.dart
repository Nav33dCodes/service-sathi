import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.emeraldGreen, size: 28),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.outfit(color: AppTheme.textDark, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 12),
              textAlign: TextAlign.center,
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
                    BoxShadow(color: AppTheme.emeraldGreenDark.withOpacity(0.5), blurRadius: 20, spreadRadius: 2)
                  ]
                ),
                child: const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Naveed+Ahmed&background=0F0C29&color=fff&size=120'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Naveed Ahmed",
                style: GoogleFonts.outfit(color: AppTheme.textDark, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.crown, color: Colors.amber, size: 16),
                    const SizedBox(width: 8),
                    Text("VIP Member", style: GoogleFonts.inter(color: Colors.amber, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  _buildStatCard("Total Bookings", "14", LucideIcons.calendarCheck),
                  const SizedBox(width: 16),
                  _buildStatCard("Saved", "Rs. 2500", LucideIcons.wallet),
                ],
              ),
              const SizedBox(height: 30),
              GlassCard(
                height: 200,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(LucideIcons.settings, color: AppTheme.emeraldGreen),
                      title: Text("Settings", style: GoogleFonts.inter(color: AppTheme.textDark)),
                      trailing: const Icon(LucideIcons.chevronRight, color: AppTheme.textMuted),
                    ),
                    const Divider(color: AppTheme.borderLight),
                    ListTile(
                      leading: const Icon(LucideIcons.creditCard, color: AppTheme.emeraldGreen),
                      title: Text("Payment Methods", style: GoogleFonts.inter(color: AppTheme.textDark)),
                      trailing: const Icon(LucideIcons.chevronRight, color: AppTheme.textMuted),
                    ),
                    const Divider(color: AppTheme.borderLight),
                    ListTile(
                      leading: const Icon(LucideIcons.logOut, color: Colors.redAccent),
                      title: Text("Logout", style: GoogleFonts.inter(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
