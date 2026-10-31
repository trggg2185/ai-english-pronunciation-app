import 'package:flutter/material.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/screens/debug_db_screen.dart';
import 'features/notifications/services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo hệ thống thông báo cục bộ
  try {
    await LocalNotificationService.instance.initialize();
  } catch (e) {
    debugPrint('[Main] Error initializing notifications: $e');
  }

  runApp(const EngPronApp());
}

class EngPronApp extends StatelessWidget {
  const EngPronApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DebugDbScreen(),
    );
  }
}
