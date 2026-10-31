import '../models/practice_session_model.dart';
import '../models/streak_model.dart';
import '../models/user_model.dart';

abstract class IDatabaseRepository {
  // User
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
  Future<void> updateDailyGoal(int minutes);

  // Practice History
  Future<void> savePracticeSession(PracticeSessionModel session);
  Future<List<PracticeSessionModel>> getPracticeHistory({int limit = 20, int offset = 0});
  Future<int> getTotalPracticeDurationSeconds();
  Future<double> getAverageScore();
  Future<void> deletePracticeSession(String id);

  // Streak
  Future<StreakModel> getStreak();
  Future<void> saveStreak(StreakModel streak);
}
