import 'package:medicationtracker/core/services/database/database_helper.dart';
import 'package:medicationtracker/data/models/userModel.dart';

class UserRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<void> createUser(UserModel user) async {
    final db = await _db.database;
    await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserById(String id) async {
    final db = await _db.database;
    final rows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await _db.database;
    final rows = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<void> updateUser(UserModel user) async {
    final db = await _db.database;
    final data = user.toMap();
    // Não sobrescrever o password se não vier explicitamente.
    if (user.passwordHash == null) data.remove('password_hash');
    await db.update('users', data, where: 'id = ?', whereArgs: [user.id]);
  }

  Future<void> deleteUser(String id) async {
    final db = await _db.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<UserModel>> getUsers() async {
    final db = await _db.database;
    final rows = await db.query('users', orderBy: 'name ASC');
    return rows.map(UserModel.fromMap).toList();
  }
}
