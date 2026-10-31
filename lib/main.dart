import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'features/feedback_exercise/data/mock_feedback_data.dart';
import 'features/feedback_exercise/screens/detailed_feedback_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI English Pronunciation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: DetailedFeedbackScreen(
        initialSession: MockFeedbackData.badEndingSoundS,
      ),
    );
  }
}
