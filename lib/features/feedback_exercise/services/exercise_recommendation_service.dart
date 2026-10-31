import '../../../data/models/phoneme_analysis.dart';
import '../../../data/models/practice_session_model.dart';
import '../data/phoneme_guide_data.dart';

/// Độ ưu tiên bài tập cải thiện
enum ExercisePriority { high, medium, low }

/// Kết quả đề xuất bài tập cho một âm vị cụ thể
class PhonemeExerciseRecommendation {
  final String targetPhoneme;
  final double lowestScore;
  final double averageScore;
  final int occurrenceCount;
  final ExercisePriority priority;
  final String reasonVi;
  final PhonemeGuide guide;
  final List<DrillWord> drillWords;

  const PhonemeExerciseRecommendation({
    required this.targetPhoneme,
    required this.lowestScore,
    required this.averageScore,
    required this.occurrenceCount,
    required this.priority,
    required this.reasonVi,
    required this.guide,
    required this.drillWords,
  });

  String get priorityLabel {
    switch (priority) {
      case ExercisePriority.high:
        return 'Ưu tiên cao (Sai nghiêm trọng)';
      case ExercisePriority.medium:
        return 'Ưu tiên trung bình (Cần rõ âm)';
      case ExercisePriority.low:
        return 'Ôn tập củng cố';
    }
  }
}

/// Dịch vụ phân tích lỗi phát âm và tạo danh sách đề xuất bài tập cải thiện
class ExerciseRecommendationService {
  /// Phân tích phiên luyện tập và tạo danh sách đề xuất bài tập chuyên sâu
  static List<PhonemeExerciseRecommendation> recommendExercises(
      PracticeSessionModel session) {
    // 1. Nhóm các kết quả theo âm vị
    final Map<String, List<PhonemeAnalysis>> groupedPhonemes = {};
    for (final analysis in session.phonemeResults) {
      final key = analysis.phoneme.replaceAll('/', '').trim();
      groupedPhonemes.putIfAbsent(key, () => []).add(analysis);
    }

    final List<PhonemeExerciseRecommendation> recommendations = [];

    // 2. Lọc các âm vị bị sai (wrong) hoặc chấp nhận được (acceptable)
    groupedPhonemes.forEach((phoneme, list) {
      final wrongCount = list.where((p) => p.isWrong).length;
      final acceptableCount = list.where((p) => p.isAcceptable).length;

      // Nếu có ít nhất 1 lần sai hoặc điểm trung bình < 80
      if (wrongCount > 0 || acceptableCount > 0) {
        double minScore = 100.0;
        double sumScore = 0.0;
        for (final p in list) {
          if (p.accuracyScore < minScore) minScore = p.accuracyScore;
          sumScore += p.accuracyScore;
        }
        final avgScore = sumScore / list.length;

        // Tính mức độ ưu tiên
        final ExercisePriority priority;
        final String reasonVi;
        if (minScore < 50 || wrongCount >= 2) {
          priority = ExercisePriority.high;
          reasonVi =
              'Bạn phát âm sai âm /$phoneme/ $wrongCount lần (điểm thấp nhất: ${minScore.toStringAsFixed(0)}%). Cần khắc phục ngay để tránh tạo thói quen sai!';
        } else if (minScore < 75) {
          priority = ExercisePriority.medium;
          reasonVi =
              'Âm /$phoneme/ đạt ${avgScore.toStringAsFixed(0)}%, người nghe vẫn hiểu nhưng cần bật âm rõ nét hơn.';
        } else {
          priority = ExercisePriority.low;
          reasonVi = 'Củng cố thêm độ mượt mà cho âm /$phoneme/.';
        }

        final guide = PhonemeGuideDatabase.getGuide(phoneme);

        recommendations.add(
          PhonemeExerciseRecommendation(
            targetPhoneme: phoneme,
            lowestScore: minScore,
            averageScore: avgScore,
            occurrenceCount: list.length,
            priority: priority,
            reasonVi: reasonVi,
            guide: guide,
            drillWords: guide.drillWords,
          ),
        );
      }
    });

    // 3. Sắp xếp danh sách bài tập theo mức độ ưu tiên (Điểm thấp nhất & High Priority lên trước)
    recommendations.sort((a, b) {
      if (a.priority != b.priority) {
        return a.priority.index.compareTo(b.priority.index);
      }
      return a.lowestScore.compareTo(b.lowestScore);
    });

    return recommendations;
  }
}
