import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/phoneme_analysis.dart';
import '../../../data/models/practice_session_model.dart';
import '../controllers/feedback_controller.dart';
import '../data/mock_feedback_data.dart';
import '../data/phoneme_guide_data.dart';
import '../services/exercise_recommendation_service.dart';
import '../widgets/mouth_shape_guide_sheet.dart';
import '../widgets/phoneme_highlighter.dart';
import '../widgets/score_card_widget.dart';
import '../widgets/waveform_comparison.dart';
import 'recommended_exercise_screen.dart';

/// Màn hình phản hồi chấm điểm chi tiết (Detailed Feedback Screen)
class DetailedFeedbackScreen extends StatefulWidget {
  final PracticeSessionModel? initialSession;

  const DetailedFeedbackScreen({super.key, this.initialSession});

  @override
  State<DetailedFeedbackScreen> createState() => _DetailedFeedbackScreenState();
}

class _DetailedFeedbackScreenState extends State<DetailedFeedbackScreen> {
  late FeedbackController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FeedbackController(initialSession: widget.initialSession);
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _openPhonemeGuide(PhonemeAnalysis phoneme) {
    _controller.selectPhoneme(phoneme);

    MouthShapeGuideSheet.show(
      context,
      phoneme: phoneme,
      onPlayNative: () => _controller.playNativeAudio(),
      onPlayUser: () => _controller.playUserAudio(),
      onPracticeNow: () {
        final guide = PhonemeGuideDatabase.getGuide(phoneme.phoneme);
        final rec = PhonemeExerciseRecommendation(
          targetPhoneme: phoneme.phoneme,
          lowestScore: phoneme.accuracyScore,
          averageScore: phoneme.accuracyScore,
          occurrenceCount: 1,
          priority: phoneme.isWrong
              ? ExercisePriority.high
              : ExercisePriority.medium,
          reasonVi: phoneme.suggestion ?? 'Luyện tập phát âm chuẩn âm /${phoneme.phoneme}/',
          guide: guide,
          drillWords: guide.drillWords,
        );
        _navigateToExercise(rec);
      },
    );
  }

  void _navigateToExercise(PhonemeExerciseRecommendation recommendation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RecommendedExerciseScreen(
          recommendation: recommendation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = _controller.currentSession;
    final recommendations = _controller.recommendations;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kết Quả Phát Âm AI',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Phân tích chi tiết từng âm vị & ngữ điệu',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          // Menu chọn kịch bản Mock kiểm thử độc lập
          PopupMenuButton<PracticeSessionModel>(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
            tooltip: 'Chọn dữ liệu thử nghiệm (Mock)',
            onSelected: (mockSession) {
              _controller.switchSession(mockSession);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã nạp dữ liệu: ${mockSession.sentenceOrWord}'),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'CHỌN KỊCH BẢN TEST MOCK:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              PopupMenuItem(
                value: MockFeedbackData.badEndingSoundS,
                child: const Row(
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: AppColors.wrongRed, size: 18),
                    SizedBox(width: 8),
                    Text('Sai âm đuôi "s" (45 điểm)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: MockFeedbackData.badThSound,
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppColors.acceptableYellow, size: 18),
                    SizedBox(width: 8),
                    Text('Sai âm "th" /θ/ (60 điểm)'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: MockFeedbackData.goodPronunciation,
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: AppColors.correctGreen, size: 18),
                    SizedBox(width: 8),
                    Text('Phát âm chuẩn (92 điểm)'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Bảng điểm trực quan với vòng tròn tiến độ lớn
            ScoreCardWidget(
              score: session.score,
              durationSeconds: session.durationSeconds,
              totalPhonemes: session.phonemeResults.length,
              wrongPhonemesCount: session.wrongPhonemes.length,
            ),

            // 2. Trực quan hóa âm vị với mã màu & tap-to-guide
            PhonemeHighlighter(
              sentence: session.sentenceOrWord,
              standardIpa: session.standardIpa,
              phonemeResults: session.phonemeResults,
              selectedPhoneme: _controller.selectedPhoneme,
              onPhonemeTap: _openPhonemeGuide,
            ),

            // 3. Đối chiếu dạng sóng & so sánh giọng mẫu
            WaveformComparisonWidget(
              isPlayingNative: _controller.isPlayingNative,
              isPlayingUser: _controller.isPlayingUser,
              playbackProgress: _controller.audioProgress,
              onPlayNative: () => _controller.playNativeAudio(),
              onPlayUser: () => _controller.playUserAudio(),
              onStop: () => _controller.stopAudio(),
            ),

            // 4. Danh sách bài tập đề xuất cải thiện
            _buildRecommendationsSection(recommendations),
          ],
        ),
      ),
      // Thanh nút cố định bên dưới để luyện tập bài tập gợi ý
      bottomNavigationBar: _buildBottomActionBar(recommendations),
    );
  }

  Widget _buildRecommendationsSection(
      List<PhonemeExerciseRecommendation> recommendations) {
    if (recommendations.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.correctGreenLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.correctGreen.withValues(alpha: 0.3)),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle_rounded,
                color: AppColors.correctGreen, size: 28),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Không phát hiện lỗi nghiêm trọng!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Tất cả các âm vị đều đạt chuẩn hoặc gần chuẩn. Hãy duy trì phong độ!',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.fitness_center_rounded,
                      color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Đề xuất bài tập cải thiện',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.wrongRedLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${recommendations.length} âm cần sửa',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.wrongRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Danh sách các thẻ đề xuất bài tập
          ...recommendations.map((rec) => _buildRecommendationCard(rec)),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(PhonemeExerciseRecommendation rec) {
    final priorityColor = rec.priority == ExercisePriority.high
        ? AppColors.wrongRed
        : (rec.priority == ExercisePriority.medium
            ? AppColors.acceptableYellow
            : AppColors.primary);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: priorityColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '/${rec.targetPhoneme}/',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: priorityColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rec.guide.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      rec.priorityLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: priorityColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _navigateToExercise(rec),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Luyện ngay',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            rec.reasonVi,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          // Các từ vựng mẫu
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: rec.drillWords.take(5).map((w) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.surfaceVariant),
                ),
                child: Text(
                  '${w.word} ${w.ipa}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
      List<PhonemeExerciseRecommendation> recommendations) {
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SizedBox(
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () => _navigateToExercise(recommendations.first),
          icon: const Icon(Icons.bolt_rounded, color: Colors.white),
          label: Text(
            'Khắc phục ngay âm /${recommendations.first.targetPhoneme}/ (${recommendations.first.drillWords.length} từ)',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
