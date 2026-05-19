import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_layout.dart';

void main() {
  runApp(const ServiceSathiApp());
}

class ServiceSathiApp extends StatelessWidget {
  const ServiceSathiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServiceSathi AI Orchestrator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.backgroundDeepBlue,
        primaryColor: AppTheme.emeraldGreen,
      ),
      home: const MainLayout(),
    );
  }
}
