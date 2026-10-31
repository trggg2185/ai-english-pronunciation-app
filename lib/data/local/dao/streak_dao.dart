import 'package:sqflite/sqflite.dart';
import '../../../core/constants/app_strings.dart';
import '../../models/streak_model.dart';
import '../app_database.dart';

class StreakDao {
  final AppDatabase _dbProvider;

  StreakDao({AppDatabase? dbProvider}) : _dbProvider = dbProvider ?? AppDatabase.instance;

  Future<StreakModel> getStreak() async {
    final db = await _dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppStrings.tableStreaks,
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return StreakModel.fromMap(maps.first);
    }
    return StreakModel.initial();
  }

  Future<int> saveStreak(StreakModel streak) async {
    final db = await _dbProvider.database;
    return await db.insert(
      AppStrings.tableStreaks,
      streak.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
