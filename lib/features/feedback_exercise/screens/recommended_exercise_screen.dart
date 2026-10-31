import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/exercise_controller.dart';
import '../data/phoneme_guide_data.dart';
import '../services/exercise_recommendation_service.dart';

/// Màn hình bài tập khắc phục nhanh từng âm vị (5 từ vựng chuyên sâu)
class RecommendedExerciseScreen extends StatefulWidget {
  final PhonemeExerciseRecommendation recommendation;

  const RecommendedExerciseScreen({
    super.key,
    required this.recommendation,
  });

  @override
  State<RecommendedExerciseScreen> createState() =>
      _RecommendedExerciseScreenState();
}

class _RecommendedExerciseScreenState extends State<RecommendedExerciseScreen>
    with SingleTickerProviderStateMixin {
  late ExerciseController _controller;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _controller = ExerciseController(recommendation: widget.recommendation);
    _controller.addListener(_onControllerUpdate);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = _controller.currentWord;
    final totalWords = widget.recommendation.drillWords.length;
    final currentIndex = _controller.currentWordIndex;
    final state = _controller.recordingState;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Luyện Âm /${widget.recommendation.targetPhoneme}/',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Từ ${currentIndex + 1}/$totalWords',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Thanh tiến độ hoàn thành 5 từ
            _buildProgressBar(currentIndex, totalWords),
            const SizedBox(height: 16),

            // Thẻ từ vựng trọng tâm (Focus Word Card)
            _buildWordCard(currentWord),
            const SizedBox(height: 16),

            // Lời nhắc khẩu hình ngắn
            _buildQuickMouthTip(),
            const SizedBox(height: 24),

            // Khu vực Tương tác: Nghe mẫu & Nút Thu âm AI
            _buildInteractiveRecordingArea(state),
            const SizedBox(height: 24),

            // Danh sách các từ điều hướng nhanh
            _buildWordThumbnailsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int current, int total) {
    final progress = (current + 1) / total;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiến độ bài tập: ${((progress) * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${_controller.wordScores.length}/$total từ đã chấm',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildWordCard(DrillWord word) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
        children: [
          // Vị trí âm vị (Vị trí đầu / giữa / cuối)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              word.position == 'initial'
                  ? 'Âm ở đầu từ'
                  : (word.position == 'medial'
                      ? 'Âm ở giữa từ'
                      : 'Âm kết thúc (Âm đuôi)'),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Từ vựng lớn nổi bật
          Text(
            word.word,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),

          // Phiên âm IPA
          Text(
            word.ipa,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),

          // Nghĩa tiếng Việt
          Text(
            word.meaningVi,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),

          // Câu ví dụ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"${word.exampleSentence}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMouthTip() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.tips_and_updates_rounded,
              size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MẸO KHẨU HÌNH NHANH',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.recommendation.guide.tonguePlacement,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveRecordingArea(DrillRecordingState state) {
    if (state == DrillRecordingState.completed && _controller.lastScore != null) {
      final score = _controller.lastScore!;
      final scoreColor = AppColors.getScoreColor(score);
      final scoreBg = AppColors.getScoreBackgroundColor(score);

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: scoreBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: scoreColor, width: 1.5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, color: scoreColor, size: 28),
                const SizedBox(width: 8),
                Text(
                  '${score.toStringAsFixed(0)} / 100 Điểm!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              score >= 80
                  ? 'Tuyệt vời! Âm /${widget.recommendation.targetPhoneme}/ phát âm rất chuẩn xác.'
                  : 'Khá tốt! Hãy cố gắng bật hơi rõ hơn một chút.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: scoreColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _controller.retryCurrentWord(),
                    icon: const Icon(Icons.replay_rounded, size: 18),
                    label: const Text('Thử lại'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: scoreColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_controller.currentWordIndex <
                          widget.recommendation.drillWords.length - 1) {
                        _controller.nextWord();
                      } else {
                        _showCompletedDialog();
                      }
                    },
                    icon: const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                    label: Text(
                      _controller.currentWordIndex <
                              widget.recommendation.drillWords.length - 1
                          ? 'Từ tiếp theo'
                          : 'Hoàn thành bài tập',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (state == DrillRecordingState.evaluating) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: const Column(
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 14),
            Text(
              'AI đang chấm điểm chi tiết âm vị...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Trạng thái thu âm bình thường hoặc đang thu âm
    final isRecording = state == DrillRecordingState.recording;

    return Column(
      children: [
        // Nút Nghe phát âm chuẩn
        TextButton.icon(
          onPressed: _controller.isPlayingAudio ? null : () => _controller.playWordSample(),
          icon: Icon(
            _controller.isPlayingAudio
                ? Icons.volume_up_rounded
                : Icons.volume_down_rounded,
            color: AppColors.primary,
          ),
          label: Text(
            _controller.isPlayingAudio ? 'Đang phát âm mẫu...' : 'Nghe phát âm chuẩn (Mẫu)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Nút Ghi Âm Lớn (Big Mic Button)
        GestureDetector(
          onTap: () {
            if (isRecording) {
              _controller.stopAndEvaluateRecording();
            } else {
              _controller.startRecording();
            }
          },
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = isRecording ? 1.0 + (_pulseController.value * 0.1) : 1.0;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isRecording ? AppColors.wrongRed : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isRecording ? AppColors.wrongRed : AppColors.primary)
                            .withValues(alpha: 0.4),
                        blurRadius: isRecording ? 20 : 12,
                        spreadRadius: isRecording ? 4 : 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isRecording
              ? 'Đang lắng nghe... Bấm để kết thúc'
              : 'Bấm micro để bắt đầu phát âm',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isRecording ? AppColors.wrongRed : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildWordThumbnailsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DANH SÁCH 5 TỪ LUYỆN TẬP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: widget.recommendation.drillWords.asMap().entries.map((entry) {
              final index = entry.key;
              final word = entry.value;
              final isCurrent = index == _controller.currentWordIndex;
              final score = _controller.wordScores[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () => _controller.selectWord(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primaryLight
                          : AppColors.surfaceVariant.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCurrent ? AppColors.primary : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          word.word,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCurrent
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        if (score != null)
                          Text(
                            '${score.toInt()}%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getScoreColor(score),
                            ),
                          )
                        else
                          const Icon(
                            Icons.circle_outlined,
                            size: 10,
                            color: AppColors.textMuted,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.military_tech_rounded,
                color: AppColors.acceptableYellow, size: 32),
            SizedBox(width: 10),
            Text('Chúc Mừng Bạn!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bạn đã hoàn thành luyện tập 5 từ vựng cho âm /${widget.recommendation.targetPhoneme}/!',
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.correctGreenLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up_rounded,
                      color: AppColors.correctGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Điểm trung bình đạt: ${_controller.averageDrillScore.toStringAsFixed(0)}/100',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.correctGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Trở về màn hình feedback chính
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Quay lại kết quả',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
