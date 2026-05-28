import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// DatabaseHelper centraliza o acesso à base de dados SQLite local.
///
/// Antes este projecto usava Firestore. Agora todos os dados ficam no
/// dispositivo numa única base SQLite (`medication_tracker.db`).
class DatabaseHelper {
  static const _databaseName = 'medication_tracker.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        roles TEXT NOT NULL,
        image TEXT,
        caregiver_id TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE medications (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        instructions TEXT,
        dosage_quantity REAL NOT NULL,
        dosage_unit TEXT NOT NULL,
        frequency_type TEXT NOT NULL,
        frequency_interval_in_days INTEGER,
        frequency_specific_days TEXT,
        scheduled_times TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT,
        receive_reminders INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        medication_id TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        scheduled_time TEXT NOT NULL,
        responded_at TEXT,
        action_taken TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (medication_id) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE caregivers (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        relationship TEXT,
        photo TEXT,
        is_linked INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (patient_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_medications_user ON medications(user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_reminders_user ON reminders(user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_reminders_medication ON reminders(medication_id)',
    );
    await db.execute(
      'CREATE INDEX idx_caregivers_patient ON caregivers(patient_id)',
    );
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
