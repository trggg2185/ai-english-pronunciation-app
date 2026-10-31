import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/features/feedback_exercise/data/mock_feedback_data.dart';
import 'package:flutter_application_1/features/feedback_exercise/screens/detailed_feedback_screen.dart';
import 'package:flutter_application_1/features/feedback_exercise/screens/recommended_exercise_screen.dart';
import 'package:flutter_application_1/features/feedback_exercise/services/exercise_recommendation_service.dart';
import 'package:flutter_application_1/features/feedback_exercise/widgets/mouth_shape_guide_sheet.dart';
import 'package:flutter_application_1/features/feedback_exercise/widgets/phoneme_highlighter.dart';
import 'package:flutter_application_1/features/feedback_exercise/widgets/score_card_widget.dart';
import 'package:flutter_application_1/features/feedback_exercise/widgets/waveform_comparison.dart';

void main() {
  testWidgets('ScoreCardWidget displays score and status correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ScoreCardWidget(
            score: 45.0,
            durationSeconds: 3,
            totalPhonemes: 16,
            wrongPhonemesCount: 4,
          ),
        ),
      ),
    );

    // Let animation finish
    await tester.pump(const Duration(milliseconds: 1300));

    expect(find.text('45'), findsOneWidget);
    expect(find.text('CẦN CHỈNH SỬA'), findsOneWidget);
    expect(find.text('3s'), findsOneWidget);
    expect(find.text('16'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('PhonemeHighlighter displays sentence, IPA and phoneme chips',
      (tester) async {
    final session = MockFeedbackData.badEndingSoundS;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhonemeHighlighter(
            sentence: session.sentenceOrWord,
            standardIpa: session.standardIpa,
            phonemeResults: session.phonemeResults,
            onPhonemeTap: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('"She likes books and cats"'), findsOneWidget);
    expect(find.text(session.standardIpa), findsOneWidget);
    expect(find.text('/s/'), findsWidgets);
  });

  testWidgets('WaveformComparisonWidget renders native & user waveform cards',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WaveformComparisonWidget(
            isPlayingNative: false,
            isPlayingUser: false,
            playbackProgress: 0.0,
            onPlayNative: () {},
            onPlayUser: () {},
            onStop: () {},
          ),
        ),
      ),
    );

    expect(find.text('MẪU BẢN NGỮ (NATIVE)'), findsOneWidget);
    expect(find.text('GIỌNG CỦA BẠN (YOU)'), findsOneWidget);
    expect(find.byType(WaveformComparisonWidget), findsOneWidget);
  });

  testWidgets('MouthShapeGuideSheet displays mouth shape guides and tips',
      (tester) async {
    final wrongPhoneme = MockFeedbackData.badEndingSoundS.wrongPhonemes.first;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MouthShapeGuideSheet(
            phoneme: wrongPhoneme,
            onPlayNative: () {},
            onPlayUser: () {},
            onPracticeNow: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('HƯỚNG DẪN KHẨU HÌNH MIỆNG CHUẨN'), findsOneWidget);
    expect(find.text('Khẩu hình tổng quan'), findsOneWidget);
    expect(find.text('Vị trí đặt lưỡi'), findsOneWidget);
    expect(find.text('Răng & Môi'), findsOneWidget);
    expect(find.text('Lỗi người Việt hay gặp'), findsOneWidget);
  });

  testWidgets(
      'DetailedFeedbackScreen renders all components correctly on screen',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        home: DetailedFeedbackScreen(
          initialSession: MockFeedbackData.badEndingSoundS,
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1300));

    // Verify main header and score card
    expect(find.text('Kết Quả Phát Âm AI'), findsOneWidget);
    expect(find.text('45'), findsOneWidget);
    expect(find.text('"She likes books and cats"'), findsOneWidget);
    expect(find.text('Phân tích chi tiết âm vị'), findsOneWidget);
    expect(find.text('Đối chiếu dạng sóng & ngữ điệu'), findsOneWidget);
    expect(find.text('Đề xuất bài tập cải thiện'), findsOneWidget);
  });

  testWidgets('RecommendedExerciseScreen shows drill words and navigates',
      (tester) async {
    final rec = ExerciseRecommendationService.recommendExercises(
      MockFeedbackData.badThSound,
    ).first;

    await tester.pumpWidget(
      MaterialApp(
        home: RecommendedExerciseScreen(recommendation: rec),
      ),
    );

    // Pump a single frame and then 100ms without pumpAndSettle due to pulsing animation
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Should show target phoneme in title
    expect(find.text('Luyện Âm /θ/'), findsOneWidget);
    // Should show the first drill word: think
    expect(find.text('think'), findsWidgets);
    expect(find.text('/θɪŋk/'), findsOneWidget);
    expect(find.text('suy nghĩ, ngẫm nghĩ'), findsOneWidget);

    // Verify mic icon exists
    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
  });
}
