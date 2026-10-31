import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Widget so sánh dạng sóng âm (Waveform) & ngữ điệu giữa người bản ngữ và người học
class WaveformComparisonWidget extends StatelessWidget {
  final bool isPlayingNative;
  final bool isPlayingUser;
  final double playbackProgress;
  final VoidCallback onPlayNative;
  final VoidCallback onPlayUser;
  final VoidCallback onStop;

  const WaveformComparisonWidget({
    super.key,
    required this.isPlayingNative,
    required this.isPlayingUser,
    required this.playbackProgress,
    required this.onPlayNative,
    required this.onPlayUser,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
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
          const Row(
            children: [
              Icon(Icons.graphic_eq_rounded, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Đối chiếu dạng sóng & ngữ điệu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 1. Dải sóng bản ngữ (Native Speaker Waveform)
          _buildWaveformCard(
            title: 'MẪU BẢN NGỮ (NATIVE)',
            icon: Icons.record_voice_over_rounded,
            color: AppColors.nativeWaveform,
            isPlaying: isPlayingNative,
            progress: isPlayingNative ? playbackProgress : 0.0,
            onPlay: onPlayNative,
            isNative: true,
          ),

          const SizedBox(height: 12),

          // 2. Dải sóng người học (User Audio Waveform)
          _buildWaveformCard(
            title: 'GIỌNG CỦA BẠN (YOU)',
            icon: Icons.person_rounded,
            color: AppColors.userWaveform,
            isPlaying: isPlayingUser,
            progress: isPlayingUser ? playbackProgress : 0.0,
            onPlay: onPlayUser,
            isNative: false,
          ),

          const SizedBox(height: 14),

          // Chú thích lỗi phát hiện qua dạng sóng
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 16, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI phát hiện biên độ sóng đuôi của bạn thấp hơn 40% so với người bản xứ (âm đuôi bị nuốt).',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool isPlaying,
    required double progress,
    required VoidCallback onPlay,
    required bool isNative,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPlaying ? color : color.withValues(alpha: 0.2),
          width: isPlaying ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: color,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: isPlaying ? onStop : onPlay,
                iconSize: 22,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: color,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Visual Custom Waveform Bars
          SizedBox(
            height: 48,
            width: double.infinity,
            child: CustomPaint(
              painter: _WaveformPainter(
                color: color,
                progress: progress,
                isNative: isNative,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final Color color;
  final double progress;
  final bool isNative;

  _WaveformPainter({
    required this.color,
    required this.progress,
    required this.isNative,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const barCount = 38;
    final barWidth = size.width / (barCount * 1.5);
    final gap = barWidth * 0.5;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + gap);
      final normalizedX = i / barCount;

      // Mô phỏng độ cao sóng âm
      final double heightFactor;
      if (isNative) {
        // Sóng chuẩn: đầy đặn, có âm đuôi rõ
        heightFactor = 0.3 + 0.6 * math.sin(i * 0.3).abs() + (i > 30 ? 0.3 : 0.0);
      } else {
        // Sóng người học: bị hụt âm ở đoạn cuối (nuốt âm)
        if (i > 28) {
          heightFactor = 0.12; // Mất biên độ ở âm đuôi!
        } else {
          heightFactor = 0.25 + 0.55 * math.sin(i * 0.32).abs();
        }
      }

      final barHeight = (size.height * 0.85 * heightFactor).clamp(4.0, size.height);
      final isPlayed = normalizedX <= progress;

      final paint = Paint()
        ..color = isPlayed ? color : color.withValues(alpha: 0.3)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = barWidth;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );

      // Nếu là sóng người học bị hụt âm ở cuối, đánh dấu chấm đỏ cảnh báo
      if (!isNative && i == 32) {
        final alertPaint = Paint()..color = AppColors.wrongRed;
        canvas.drawCircle(Offset(x, centerY - barHeight / 2 - 4), 3, alertPaint);
      }
    }

    // Vẽ thanh chỉ báo vị trí phát (Playback Scrubber)
    if (progress > 0) {
      final scrubberX = progress * size.width;
      final scrubberPaint = Paint()
        ..color = color
        ..strokeWidth = 2.0;
      canvas.drawLine(
        Offset(scrubberX, 0),
        Offset(scrubberX, size.height),
        scrubberPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isNative != isNative;
  }
}
