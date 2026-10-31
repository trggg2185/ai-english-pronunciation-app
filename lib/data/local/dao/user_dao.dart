import 'package:sqflite/sqflite.dart';
import '../../../core/constants/app_strings.dart';
import '../../models/user_model.dart';
import '../app_database.dart';

class UserDao {
  final AppDatabase _dbProvider;

  UserDao({AppDatabase? dbProvider}) : _dbProvider = dbProvider ?? AppDatabase.instance;

  Future<UserModel?> getUser() async {
    final db = await _dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppStrings.tableUsers,
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertOrUpdateUser(UserModel user) async {
    final db = await _dbProvider.database;
    return await db.insert(
      AppStrings.tableUsers,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateDailyGoal(int minutes) async {
    final db = await _dbProvider.database;
    return await db.rawUpdate(
      'UPDATE ${AppStrings.tableUsers} SET daily_target_minutes = ?',
      [minutes],
    );
  }
}
