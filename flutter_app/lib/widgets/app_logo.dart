import 'package:flutter/material.dart';

class ServiceSathiLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const ServiceSathiLogo({
    Key? key,
    this.size = 80.0,
    this.showText = true,
    this.isDark = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Premium color palette (Deep Navy Blue & Emerald Green)
    final Color primaryBlue = const Color(0xFF0A3D62);
    final Color emeraldGreen = const Color(0xFF00D9FF);
    final Color darkBackground = const Color(0xFF0D1117);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // The Logo Emblem
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                primaryBlue,
                primaryBlue.withBlue(150),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withOpacity(0.3),
                blurRadius: size * 0.2,
                offset: Offset(0, size * 0.1),
              ),
              BoxShadow(
                color: emeraldGreen.withOpacity(0.2),
                blurRadius: size * 0.1,
                offset: Offset(0, -size * 0.05),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // outer glowing border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: emeraldGreen.withOpacity(0.4),
                    width: size * 0.03,
                  ),
                ),
              ),
              // Inside Emblem: Gear + House + AI sparkles shape
              Icon(
                Icons.home_repair_service_rounded,
                size: size * 0.5,
                color: Colors.white,
              ),
              // Sparkle Icon (representing AI Orchestrator)
              Positioned(
                top: size * 0.2,
                right: size * 0.2,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: size * 0.22,
                  color: emeraldGreen,
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.15),
          // App Title
          Text(
            'ServiceSathi AI',
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: isDark ? Colors.white : darkBackground,
            ),
          ),
          SizedBox(height: size * 0.04),
          // App Subtitle / Tagline
          Text(
            'Ghar ki zaroorat, ek awaaz mein.',
            style: TextStyle(
              fontSize: size * 0.12,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
