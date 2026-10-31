import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Widget hiển thị Bảng điểm trực quan với vòng tròn tiến độ lớn và phân cấp màu chuẩn
class ScoreCardWidget extends StatefulWidget {
  final double score; // Điểm từ 0 - 100
  final int durationSeconds;
  final int totalPhonemes;
  final int wrongPhonemesCount;

  const ScoreCardWidget({
    super.key,
    required this.score,
    required this.durationSeconds,
    required this.totalPhonemes,
    required this.wrongPhonemesCount,
  });

  @override
  State<ScoreCardWidget> createState() => _ScoreCardWidgetState();
}

class _ScoreCardWidgetState extends State<ScoreCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnimation = Tween<double>(begin: 0.0, end: widget.score).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant ScoreCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _scoreAnimation = Tween<double>(
        begin: _scoreAnimation.value,
        end: widget.score,
      ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
      );
      _animController.reset();
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = AppColors.getScoreColor(widget.score);
    final scoreBgColor = AppColors.getScoreBackgroundColor(widget.score);

    final String statusTitle;
    final String statusSubtitle;
    final IconData statusIcon;

    if (widget.score >= 80) {
      statusTitle = 'Tuyệt vời! Phát âm rất chuẩn';
      statusSubtitle = 'Bạn đã làm chủ phần lớn các âm vị trong câu này.';
      statusIcon = Icons.stars_rounded;
    } else if (widget.score >= 50) {
      statusTitle = 'Khá tốt! Cần chú ý âm nối & âm cuối';
      statusSubtitle = 'Người nghe vẫn hiểu nhưng cần bật rõ một số âm vị.';
      statusIcon = Icons.thumb_up_alt_rounded;
    } else {
      statusTitle = 'Cần luyện tập thêm';
      statusSubtitle = 'Có một số âm vị bị nuốt hoặc nhầm lẫn cần sửa ngay.';
      statusIcon = Icons.warning_amber_rounded;
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
        border: Border.all(
          color: scoreColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Vòng tròn điểm số Animated Circular Gauge
              AnimatedBuilder(
                animation: _scoreAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: 110,
                    height: 110,
                    child: CustomPaint(
                      painter: _CircularGaugePainter(
                        score: _scoreAnimation.value,
                        primaryColor: scoreColor,
                        backgroundColor: scoreBgColor,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _scoreAnimation.value.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: scoreColor,
                                height: 1.1,
                              ),
                            ),
                            const Text(
                              '/ 100',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              // Thông tin đánh giá
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(statusIcon, color: scoreColor, size: 20),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: scoreBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.score >= 80
                                ? 'ĐẠT CHUẨN'
                                : (widget.score >= 50
                                    ? 'CẦN CẢI THIỆN'
                                    : 'CẦN CHỈNH SỬA'),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      statusTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.surfaceVariant),
          const SizedBox(height: 14),
          // Các chỉ số phụ (Sub-metrics)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem(
                icon: Icons.timer_outlined,
                label: 'Thời gian',
                value: '${widget.durationSeconds}s',
                color: AppColors.primary,
              ),
              _buildMetricItem(
                icon: Icons.graphic_eq_rounded,
                label: 'Tổng âm vị',
                value: '${widget.totalPhonemes}',
                color: AppColors.accent,
              ),
              _buildMetricItem(
                icon: Icons.error_outline_rounded,
                label: 'Âm cần sửa',
                value: '${widget.wrongPhonemesCount}',
                color: widget.wrongPhonemesCount > 0
                    ? AppColors.wrongRed
                    : AppColors.correctGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

/// Custom Painter vẽ vòng tròn đo điểm số
class _CircularGaugePainter extends CustomPainter {
  final double score;
  final Color primaryColor;
  final Color backgroundColor;

  _CircularGaugePainter({
    required this.score,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;
    const strokeWidth = 9.0;

    // Vòng nền (Background track)
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Vòng tiến độ (Progress arc)
    final progressPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = (score / 100) * 2 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularGaugePainter oldDelegate) {
    return oldDelegate.score != score ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
