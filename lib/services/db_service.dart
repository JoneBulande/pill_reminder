import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pill_reminder/core/model/medicine.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  static Database? _database;

  DBService._internal();

  factory DBService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'medicine.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id       INTEGER PRIMARY KEY,
            username TEXT UNIQUE,
            email    TEXT UNIQUE,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE medicines (
            id            INTEGER PRIMARY KEY AUTOINCREMENT,
            name          TEXT,
            time          TEXT,
            intervalHours INTEGER,
            userName      TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // ── Auth ──────────────────────────────────────────────────────────────

  Future<void> registerUser(
      String userName, String userEmail, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': userName, 'email': userEmail, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> loginUser(
      String userEmail, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [userEmail, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateUserPassword(String userEmail, String newPassword) async {
    final db = await database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [userEmail],
    );
  }

  // ── Medicines ─────────────────────────────────────────────────────────

  Future<int> insertMedicine(Medicine medicine) async {
    final db = await database;
    return db.insert('medicines', medicine.toMap());
  }

  Future<List<Medicine>> getMedicinesByUser({required String userName}) async {
    final db = await database;
    final result = await db.query(
      'medicines',
      where: 'userName = ?',
      whereArgs: [userName],
    );
    return result.map((map) => Medicine.fromMap(map)).toList();
  }

  Future<int> deleteMedicine(int id) async {
    final db = await database;
    return db.delete('medicines', where: 'id = ?', whereArgs: [id]);
  }
}
