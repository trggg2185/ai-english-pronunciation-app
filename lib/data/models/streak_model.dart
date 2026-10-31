class StreakModel {
  final int currentStreak; // Chuỗi ngày hiện tại
  final int longestStreak; // Kỷ lục streak dài nhất
  final DateTime? lastPracticeDate; // Ngày luyện tập gần nhất
  final List<String> activeDates; // Danh sách 'yyyy-MM-dd' đã hoàn thành

  StreakModel({
    required this.currentStreak,
    required this.longestStreak,
    this.lastPracticeDate,
    required this.activeDates,
  });

  Map<String, dynamic> toMap() => {
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'lastPracticeDate': lastPracticeDate?.toIso8601String(),
        'activeDates': activeDates,
      };

  factory StreakModel.fromMap(Map<String, dynamic> map) => StreakModel(
        currentStreak: (map['currentStreak'] as num).toInt(),
        longestStreak: (map['longestStreak'] as num).toInt(),
        lastPracticeDate: map['lastPracticeDate'] != null
            ? DateTime.parse(map['lastPracticeDate'] as String)
            : null,
        activeDates: List<String>.from(map['activeDates'] as List<dynamic>),
      );
}

