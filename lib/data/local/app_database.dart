import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';

class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Users Table
    await db.execute('''
      CREATE TABLE ${AppStrings.tableUsers} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        daily_target_minutes INTEGER NOT NULL DEFAULT 15,
        created_at TEXT NOT NULL
      )
    ''');

    // 2. Practice History Table
    await db.execute('''
      CREATE TABLE ${AppStrings.tablePracticeHistory} (
        id TEXT PRIMARY KEY,
        sentence_or_word TEXT NOT NULL,
        standard_ipa TEXT,
        score REAL NOT NULL,
        duration_seconds INTEGER NOT NULL DEFAULT 0,
        audio_path TEXT,
        practiced_at TEXT NOT NULL,
        phoneme_json TEXT
      )
    ''');

    // 3. User Streaks Table
    await db.execute('''
      CREATE TABLE ${AppStrings.tableStreaks} (
        id INTEGER PRIMARY KEY,
        current_streak INTEGER NOT NULL DEFAULT 0,
        longest_streak INTEGER NOT NULL DEFAULT 0,
        last_practice_date TEXT,
        active_dates_json TEXT
      )
    ''');

    // Insert initial default user and streak
    await db.insert(AppStrings.tableUsers, {
      'id': 'user_default_01',
      'name': 'Nguyễn Thế Trưởng',
      'email': 'truong.nt@example.com',
      'daily_target_minutes': 15,
      'created_at': DateTime.now().toIso8601String(),
    });

    await db.insert(AppStrings.tableStreaks, {
      'id': 1,
      'current_streak': 0,
      'longest_streak': 0,
      'last_practice_date': null,
      'active_dates_json': '[]',
    });
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
