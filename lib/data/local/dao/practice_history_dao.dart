import 'package:sqflite/sqflite.dart';
import '../../../core/constants/app_strings.dart';
import '../../models/practice_session_model.dart';
import '../app_database.dart';

class PracticeHistoryDao {
  final AppDatabase _dbProvider;

  PracticeHistoryDao({AppDatabase? dbProvider}) : _dbProvider = dbProvider ?? AppDatabase.instance;

  Future<int> insertSession(PracticeSessionModel session) async {
    final db = await _dbProvider.database;
    return await db.insert(
      AppStrings.tablePracticeHistory,
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PracticeSessionModel>> getSessions({int limit = 20, int offset = 0}) async {
    final db = await _dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppStrings.tablePracticeHistory,
      orderBy: 'practiced_at DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => PracticeSessionModel.fromMap(map)).toList();
  }

  Future<int> getTotalPracticeDurationSeconds() async {
    final db = await _dbProvider.database;
    final result = await db.rawQuery(
      'SELECT SUM(duration_seconds) as total FROM ${AppStrings.tablePracticeHistory}',
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toInt();
    }
    return 0;
  }

  Future<double> getAverageScore() async {
    final db = await _dbProvider.database;
    final result = await db.rawQuery(
      'SELECT AVG(score) as avg_score FROM ${AppStrings.tablePracticeHistory}',
    );

    if (result.isNotEmpty && result.first['avg_score'] != null) {
      return (result.first['avg_score'] as num).toDouble();
    }
    return 0.0;
  }

  Future<int> deleteSession(String id) async {
    final db = await _dbProvider.database;
    return await db.delete(
      AppStrings.tablePracticeHistory,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearAll() async {
    final db = await _dbProvider.database;
    return await db.delete(AppStrings.tablePracticeHistory);
  }
}
