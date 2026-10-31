import 'dart:convert';

class StreakModel {
  final int currentStreak;          // Chuỗi ngày hiện tại
  final int longestStreak;          // Kỷ lục streak dài nhất
  final DateTime? lastPracticeDate; // Ngày luyện tập gần nhất
  final List<String> activeDates;   // Danh sách 'yyyy-MM-dd' đã hoàn thành

  StreakModel({
    required this.currentStreak,
    required this.longestStreak,
    this.lastPracticeDate,
    required this.activeDates,
  });

  Map<String, dynamic> toMap() => {
    'id': 1, // Single user row
    'current_streak': currentStreak,
    'longest_streak': longestStreak,
    'last_practice_date': lastPracticeDate?.toIso8601String(),
    'active_dates_json': jsonEncode(activeDates),
  };

  factory StreakModel.fromMap(Map<String, dynamic> map) {
    List<String> dates = [];
    if (map['active_dates_json'] != null) {
      try {
        final List<dynamic> list = jsonDecode(map['active_dates_json'] as String);
        dates = list.map((e) => e.toString()).toList();
      } catch (_) {}
    }

    return StreakModel(
      currentStreak: map['current_streak'] as int? ?? 0,
      longestStreak: map['longest_streak'] as int? ?? 0,
      lastPracticeDate: map['last_practice_date'] != null 
          ? DateTime.tryParse(map['last_practice_date'] as String) 
          : null,
      activeDates: dates,
    );
  }

  factory StreakModel.initial() {
    return StreakModel(
      currentStreak: 0,
      longestStreak: 0,
      lastPracticeDate: null,
      activeDates: [],
    );
  }
}
