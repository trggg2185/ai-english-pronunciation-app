import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/phoneme_analysis.dart';
import '../data/phoneme_guide_data.dart';

/// BottomSheet hiển thị hướng dẫn khẩu hình miệng chi tiết khi chạm vào âm vị
class MouthShapeGuideSheet extends StatefulWidget {
  final PhonemeAnalysis phoneme;
  final VoidCallback onPlayNative;
  final VoidCallback onPlayUser;
  final VoidCallback onPracticeNow;

  const MouthShapeGuideSheet({
    super.key,
    required this.phoneme,
    required this.onPlayNative,
    required this.onPlayUser,
    required this.onPracticeNow,
  });

  /// Hàm tiện ích mở BottomSheet
  static Future<void> show(
    BuildContext context, {
    required PhonemeAnalysis phoneme,
    required VoidCallback onPlayNative,
    required VoidCallback onPlayUser,
    required VoidCallback onPracticeNow,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => MouthShapeGuideSheet(
        phoneme: phoneme,
        onPlayNative: onPlayNative,
        onPlayUser: onPlayUser,
        onPracticeNow: onPracticeNow,
      ),
    );
  }

  @override
  State<MouthShapeGuideSheet> createState() => _MouthShapeGuideSheetState();
}

class _MouthShapeGuideSheetState extends State<MouthShapeGuideSheet> {
  bool _isPlayingNative = false;
  bool _isPlayingUser = false;

  @override
  Widget build(BuildContext context) {
    final guide = PhonemeGuideDatabase.getGuide(widget.phoneme.phoneme);
    final scoreColor = AppColors.getScoreColor(widget.phoneme.accuracyScore);
    final scoreBg = AppColors.getScoreBackgroundColor(widget.phoneme.accuracyScore);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thanh kéo modal (Drag handle)
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Nội dung cuộn
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề âm vị và điểm số
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: scoreBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: scoreColor, width: 1.5),
                        ),
                        child: Text(
                          '/${widget.phoneme.phoneme}/',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guide.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              guide.category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Điểm chính xác
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.phoneme.accuracyScore.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                          Text(
                            widget.phoneme.isCorrect
                                ? 'Đạt chuẩn'
                                : (widget.phoneme.isAcceptable
                                    ? 'Cần rõ hơn'
                                    : 'Chưa đạt'),
                            style: TextStyle(
                              fontSize: 11,
                              color: scoreColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // 2 Nút nghe âm thanh: Nghe mẫu bản ngữ & Nghe lại bản thu
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() => _isPlayingNative = true);
                            widget.onPlayNative();
                            Future.delayed(
                                const Duration(milliseconds: 1500), () {
                              if (mounted) {
                                setState(() => _isPlayingNative = false);
                              }
                            });
                          },
                          icon: Icon(
                            _isPlayingNative
                                ? Icons.volume_up_rounded
                                : Icons.play_arrow_rounded,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            _isPlayingNative ? 'Đang phát...' : 'Nghe âm mẫu',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() => _isPlayingUser = true);
                            widget.onPlayUser();
                            Future.delayed(
                                const Duration(milliseconds: 1500), () {
                              if (mounted) {
                                setState(() => _isPlayingUser = false);
                              }
                            });
                          },
                          icon: Icon(
                            _isPlayingUser
                                ? Icons.hearing_rounded
                                : Icons.replay_rounded,
                            color: AppColors.accent,
                          ),
                          label: Text(
                            _isPlayingUser ? 'Đang phát...' : 'Nghe lại bạn đọc',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.accent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Lời khuyên nhanh từ AI (nếu có)
                  if (widget.phoneme.suggestion != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.wrongRedLight.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.wrongRed.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.feedback_rounded,
                              size: 18, color: AppColors.wrongRed),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.phoneme.suggestion!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.wrongRed,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Chi tiết khẩu hình miệng (Mouth shape cards)
                  const Text(
                    'HƯỚNG DẪN KHẨU HÌNH MIỆNG CHUẨN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildGuideStep(
                    icon: Icons.record_voice_over_rounded,
                    title: 'Khẩu hình tổng quan',
                    content: guide.mouthShapeGuide,
                    color: AppColors.primary,
                  ),
                  _buildGuideStep(
                    icon: Icons.compress_rounded,
                    title: 'Vị trí đặt lưỡi',
                    content: guide.tonguePlacement,
                    color: AppColors.accent,
                  ),
                  _buildGuideStep(
                    icon: Icons.sentiment_satisfied_alt_rounded,
                    title: 'Răng & Môi',
                    content: guide.lipsAndTeeth,
                    color: AppColors.acceptableYellow,
                  ),
                  _buildGuideStep(
                    icon: Icons.warning_amber_rounded,
                    title: 'Lỗi người Việt hay gặp',
                    content: guide.commonVietnameseError,
                    color: AppColors.wrongRed,
                  ),
                  _buildGuideStep(
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Mẹo nhớ nhanh',
                    content: guide.proTip,
                    color: AppColors.correctGreen,
                  ),

                  const SizedBox(height: 20),

                  // Nút Hành động chính: Luyện ngay âm này!
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onPracticeNow();
                      },
                      icon: const Icon(Icons.fitness_center_rounded,
                          color: Colors.white),
                      label: Text(
                        'Luyện ngay âm /${widget.phoneme.phoneme}/ (5 từ chuyên sâu)',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideStep({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
