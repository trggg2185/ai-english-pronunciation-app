import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/phoneme_analysis.dart';

/// Widget hiển thị trực quan các âm vị với mã màu và tương tác chạm
class PhonemeHighlighter extends StatelessWidget {
  final String sentence;
  final String standardIpa;
  final List<PhonemeAnalysis> phonemeResults;
  final PhonemeAnalysis? selectedPhoneme;
  final ValueChanged<PhonemeAnalysis> onPhonemeTap;

  const PhonemeHighlighter({
    super.key,
    required this.sentence,
    required this.standardIpa,
    required this.phonemeResults,
    this.selectedPhoneme,
    required this.onPhonemeTap,
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
          // Tiêu đề & Chú thích màu sắc
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.mic_external_on_rounded,
                      color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Phân tích chi tiết âm vị',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              _buildLegendRow(),
            ],
          ),
          const SizedBox(height: 14),

          // Câu văn bản gốc lớn, dễ đọc
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CÂU LUYỆN TẬP:',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '"$sentence"',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  standardIpa,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Hướng dẫn tương tác nhanh
          Row(
            children: [
              const Icon(Icons.touch_app_rounded,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Chạm vào từng âm vị bên dưới để xem hướng dẫn khẩu hình:',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Danh sách các âm vị dạng Wrap badges
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: phonemeResults.map((phoneme) {
              final isSelected = selectedPhoneme == phoneme;
              return _buildPhonemeChip(phoneme, isSelected);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLegendDot(AppColors.correctGreen, 'Đúng'),
        const SizedBox(width: 8),
        _buildLegendDot(AppColors.acceptableYellow, 'Khá'),
        const SizedBox(width: 8),
        _buildLegendDot(AppColors.wrongRed, 'Sai'),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildPhonemeChip(PhonemeAnalysis phoneme, bool isSelected) {
    final Color badgeColor;
    final Color badgeBg;
    final IconData statusIcon;

    switch (phoneme.status) {
      case PhonemeStatus.correct:
        badgeColor = AppColors.correctGreen;
        badgeBg = AppColors.correctGreenLight;
        statusIcon = Icons.check_circle_rounded;
        break;
      case PhonemeStatus.acceptable:
        badgeColor = AppColors.acceptableYellow;
        badgeBg = AppColors.acceptableYellowLight;
        statusIcon = Icons.info_rounded;
        break;
      case PhonemeStatus.wrong:
        badgeColor = AppColors.wrongRed;
        badgeBg = AppColors.wrongRedLight;
        statusIcon = Icons.cancel_rounded;
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onPhonemeTap(phoneme),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? badgeColor : badgeBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? badgeColor : badgeColor.withValues(alpha: 0.4),
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: badgeColor.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                statusIcon,
                size: 14,
                color: isSelected ? Colors.white : badgeColor,
              ),
              const SizedBox(width: 5),
              Text(
                '/${phoneme.phoneme}/',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : badgeColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${phoneme.accuracyScore.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.9)
                      : badgeColor.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
