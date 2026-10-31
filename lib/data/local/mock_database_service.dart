import '../models/phoneme_analysis.dart';
import '../models/practice_session_model.dart';
import '../models/streak_model.dart';
import '../models/user_model.dart';
import 'i_database_repository.dart';

/// Dịch vụ Mock Database dùng bộ nhớ RAM:
/// Cho phép các thành viên (Đức, Hà, Đại) kiểm thử độc lập mà không cần tạo file SQLite thật.
class MockDatabaseService implements IDatabaseRepository {
  UserModel _user = UserModel(
    id: 'user_mock_01',
    name: 'Nguyễn Thế Trưởng (Mock)',
    email: 'truong.mock@example.com',
    dailyTargetMinutes: 15,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  StreakModel _streak = StreakModel(
    currentStreak: 5,
    longestStreak: 12,
    lastPracticeDate: DateTime.now().subtract(const Duration(hours: 4)),
    activeDates: [
      DateTime.now().subtract(const Duration(days: 4)).toIso8601String().substring(0, 10),
      DateTime.now().subtract(const Duration(days: 3)).toIso8601String().substring(0, 10),
      DateTime.now().subtract(const Duration(days: 2)).toIso8601String().substring(0, 10),
      DateTime.now().subtract(const Duration(days: 1)).toIso8601String().substring(0, 10),
      DateTime.now().toIso8601String().substring(0, 10),
    ],
  );

  final List<PracticeSessionModel> _sessions = [
    PracticeSessionModel(
      id: 'mock_session_1',
      sentenceOrWord: 'Hello world',
      standardIpa: '/həˈloʊ wɜːrld/',
      score: 88.5,
      durationSeconds: 45,
      practicedAt: DateTime.now().subtract(const Duration(hours: 3)),
      audioRecordPath: '/mock/audio1.wav',
      phonemeResults: [
        PhonemeAnalysis(phoneme: 'h', accuracyScore: 95.0, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'ə', accuracyScore: 90.0, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'l', accuracyScore: 88.0, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'oʊ', accuracyScore: 85.0, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'w', accuracyScore: 92.0, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'ɜːr', accuracyScore: 78.0, status: PhonemeStatus.acceptable, suggestion: 'Uốn lưỡi nhẹ hơn'),
        PhonemeAnalysis(phoneme: 'l', accuracyScore: 85.0, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'd', accuracyScore: 90.0, status: PhonemeStatus.correct),
      ],
    ),
    PracticeSessionModel(
      id: 'mock_session_2',
      sentenceOrWord: 'Think positive',
      standardIpa: '/θɪŋk ˈpɑːzətɪv/',
      score: 62.0,
      durationSeconds: 60,
      practicedAt: DateTime.now().subtract(const Duration(days: 1)),
      audioRecordPath: '/mock/audio2.wav',
      phonemeResults: [
        PhonemeAnalysis(phoneme: 'θ', accuracyScore: 40.0, status: PhonemeStatus.wrong, suggestion: 'Đặt đầu lưỡi giữa hai hàm răng và thổi hơi'),
        PhonemeAnalysis(phoneme: 'ɪ', accuracyScore: 80.0, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'ŋ', accuracyScore: 85.0, status: PhonemeStatus.correct),
        PhonemeAnalysis(phoneme: 'k', accuracyScore: 75.0, status: PhonemeStatus.acceptable),
      ],
    ),
  ];

  @override
  Future<UserModel?> getUser() async => _user;

  @override
  Future<void> saveUser(UserModel user) async {
    _user = user;
  }

  @override
  Future<void> updateDailyGoal(int minutes) async {
    _user = _user.copyWith(dailyTargetMinutes: minutes);
  }

  @override
  Future<void> savePracticeSession(PracticeSessionModel session) async {
    _sessions.insert(0, session);
  }

  @override
  Future<List<PracticeSessionModel>> getPracticeHistory({int limit = 20, int offset = 0}) async {
    if (offset >= _sessions.length) return [];
    final end = (offset + limit < _sessions.length) ? offset + limit : _sessions.length;
    return _sessions.sublist(offset, end);
  }

  @override
  Future<int> getTotalPracticeDurationSeconds() async {
    return _sessions.fold<int>(0, (int sum, item) => sum + item.durationSeconds);
  }

  @override
  Future<double> getAverageScore() async {
    if (_sessions.isEmpty) return 0.0;
    final double total = _sessions.fold<double>(0.0, (double sum, item) => sum + item.score);
    return total / _sessions.length;
  }

  @override
  Future<void> deletePracticeSession(String id) async {
    _sessions.removeWhere((item) => item.id == id);
  }

  @override
  Future<StreakModel> getStreak() async => _streak;

  @override
  Future<void> saveStreak(StreakModel streak) async {
    _streak = streak;
  }
}
