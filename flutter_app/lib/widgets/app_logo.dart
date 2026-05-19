import 'package:flutter/material.dart';

class ServiceSathiLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const ServiceSathiLogo({
    super.key,
    this.size = 80.0,
    this.showText = true,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    // Premium color palette (OLED000 cyber style)
    final Color primaryBlue = const Color(0xFF000000);
    final Color emeraldGreen = const Color(0xFF00FF9D);
    final Color darkBackground = const Color(0xFF000000);

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
            color: Colors.white.withValues(alpha: 0.05),
            boxShadow: [
              BoxShadow(
                color: primaryBlue.withValues(alpha: 0.2),
                blurRadius: size * 0.2,
                offset: Offset(0, size * 0.1),
              ),
              BoxShadow(
                color: emeraldGreen.withValues(alpha: 0.15),
                blurRadius: size * 0.1,
                offset: Offset(0, -size * 0.05),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glowing border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: emeraldGreen.withValues(alpha: 0.3),
                    width: size * 0.03,
                  ),
                ),
              ),
              // Inside Emblem: The new app icon image
              Padding(
                padding: EdgeInsets.all(size * 0.08),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size * 0.5),
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    fit: BoxFit.contain,
                  ),
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
