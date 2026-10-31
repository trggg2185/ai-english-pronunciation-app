import 'package:flutter_test/flutter_test.dart';
import 'package:eng_pron_app/data/local/mock_database_service.dart';
import 'package:eng_pron_app/data/models/phoneme_analysis.dart';
import 'package:eng_pron_app/data/models/practice_session_model.dart';
import 'package:eng_pron_app/data/models/streak_model.dart';
import 'package:eng_pron_app/data/models/user_model.dart';

void main() {
  group('Data Models Serialization Tests', () {
    test('UserModel toMap and fromMap should be consistent', () {
      final now = DateTime.now();
      final user = UserModel(
        id: 'u123',
        name: 'Nguyễn Thế Trưởng',
        email: 'truong@test.com',
        dailyTargetMinutes: 20,
        createdAt: now,
      );

      final map = user.toMap();
      final fromMap = UserModel.fromMap(map);

      expect(fromMap.id, equals('u123'));
      expect(fromMap.name, equals('Nguyễn Thế Trưởng'));
      expect(fromMap.email, equals('truong@test.com'));
      expect(fromMap.dailyTargetMinutes, equals(20));
      expect(fromMap.createdAt.toIso8601String(), equals(now.toIso8601String()));
    });

    test('StreakModel toMap and fromMap should handle active dates JSON correctly', () {
      final now = DateTime.now();
      final streak = StreakModel(
        currentStreak: 7,
        longestStreak: 14,
        lastPracticeDate: now,
        activeDates: ['2026-10-25', '2026-10-26', '2026-10-27'],
      );

      final map = streak.toMap();
      final fromMap = StreakModel.fromMap(map);

      expect(fromMap.currentStreak, equals(7));
      expect(fromMap.longestStreak, equals(14));
      expect(fromMap.activeDates.length, equals(3));
      expect(fromMap.activeDates, contains('2026-10-26'));
    });

    test('PracticeSessionModel serialization should preserve phoneme details', () {
      final session = PracticeSessionModel(
        id: 'session_01',
        sentenceOrWord: 'thank you',
        standardIpa: '/θæŋk juː/',
        score: 82.5,
        durationSeconds: 15,
        practicedAt: DateTime.now(),
        audioRecordPath: '/test/audio.wav',
        phonemeResults: [
          PhonemeAnalysis(phoneme: 'θ', accuracyScore: 60.0, status: PhonemeStatus.acceptable),
          PhonemeAnalysis(phoneme: 'æ', accuracyScore: 90.0, status: PhonemeStatus.correct),
          PhonemeAnalysis(phoneme: 'ŋ', accuracyScore: 88.0, status: PhonemeStatus.correct),
          PhonemeAnalysis(phoneme: 'k', accuracyScore: 40.0, status: PhonemeStatus.wrong, suggestion: 'Bật hơi âm /k/'),
        ],
      );

      final map = session.toMap();
      final fromMap = PracticeSessionModel.fromMap(map);

      expect(fromMap.id, equals('session_01'));
      expect(fromMap.sentenceOrWord, equals('thank you'));
      expect(fromMap.score, equals(82.5));
      expect(fromMap.phonemeResults.length, equals(4));
      expect(fromMap.phonemeResults[0].phoneme, equals('θ'));
      expect(fromMap.phonemeResults[3].status, equals(PhonemeStatus.wrong));
      expect(fromMap.phonemeResults[3].suggestion, equals('Bật hơi âm /k/'));
    });
  });

  group('MockDatabaseService CRUD & Business Logic Tests', () {
    late MockDatabaseService dbService;

    setUp(() {
      dbService = MockDatabaseService();
    });

    test('Should read initial user and update daily goal', () async {
      final user = await dbService.getUser();
      expect(user, isNotNull);
      expect(user!.name, contains('Nguyễn Thế Trưởng'));

      await dbService.updateDailyGoal(30);
      final updatedUser = await dbService.getUser();
      expect(updatedUser!.dailyTargetMinutes, equals(30));
    });

    test('Should add, read, and delete practice sessions', () async {
      final initialHistory = await dbService.getPracticeHistory();
      final initialCount = initialHistory.length;

      final newSession = PracticeSessionModel(
        id: 'new_session_99',
        sentenceOrWord: 'water',
        standardIpa: '/ˈwɔːtər/',
        score: 95.0,
        durationSeconds: 20,
        practicedAt: DateTime.now(),
        audioRecordPath: '/test/w.wav',
        phonemeResults: [],
      );

      await dbService.savePracticeSession(newSession);
      final afterAdd = await dbService.getPracticeHistory();
      expect(afterAdd.length, equals(initialCount + 1));
      expect(afterAdd.first.id, equals('new_session_99'));

      await dbService.deletePracticeSession('new_session_99');
      final afterDelete = await dbService.getPracticeHistory();
      expect(afterDelete.length, equals(initialCount));
    });

    test('Should calculate average score and duration accurately', () async {
      final avg = await dbService.getAverageScore();
      expect(avg, greaterThan(0));

      final duration = await dbService.getTotalPracticeDurationSeconds();
      expect(duration, greaterThan(0));
    });
  });
}
