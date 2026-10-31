import '../models/practice_session_model.dart';
import '../models/streak_model.dart';
import '../models/user_model.dart';
import 'dao/practice_history_dao.dart';
import 'dao/streak_dao.dart';
import 'dao/user_dao.dart';
import 'i_database_repository.dart';

class DatabaseRepository implements IDatabaseRepository {
  final UserDao _userDao;
  final PracticeHistoryDao _historyDao;
  final StreakDao _streakDao;

  DatabaseRepository({
    UserDao? userDao,
    PracticeHistoryDao? historyDao,
    StreakDao? streakDao,
  })  : _userDao = userDao ?? UserDao(),
        _historyDao = historyDao ?? PracticeHistoryDao(),
        _streakDao = streakDao ?? StreakDao();

  @override
  Future<UserModel?> getUser() => _userDao.getUser();

  @override
  Future<void> saveUser(UserModel user) async {
    await _userDao.insertOrUpdateUser(user);
  }

  @override
  Future<void> updateDailyGoal(int minutes) async {
    await _userDao.updateDailyGoal(minutes);
  }

  @override
  Future<void> savePracticeSession(PracticeSessionModel session) async {
    await _historyDao.insertSession(session);
  }

  @override
  Future<List<PracticeSessionModel>> getPracticeHistory({int limit = 20, int offset = 0}) {
    return _historyDao.getSessions(limit: limit, offset: offset);
  }

  @override
  Future<int> getTotalPracticeDurationSeconds() {
    return _historyDao.getTotalPracticeDurationSeconds();
  }

  @override
  Future<double> getAverageScore() {
    return _historyDao.getAverageScore();
  }

  @override
  Future<void> deletePracticeSession(String id) async {
    await _historyDao.deleteSession(id);
  }

  @override
  Future<StreakModel> getStreak() => _streakDao.getStreak();

  @override
  Future<void> saveStreak(StreakModel streak) async {
    await _streakDao.saveStreak(streak);
  }
}
