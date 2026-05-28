import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:medicationtracker/core/services/database/database_helper.dart';
import 'package:medicationtracker/core/services/session_manager.dart';
import 'package:medicationtracker/core/utils/error.dart';
import 'package:medicationtracker/core/utils/result.dart';
import 'package:medicationtracker/data/models/userModel.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Serviço de autenticação **local** (SQLite). Substitui o antigo
/// `FirebaseAuth` mantendo praticamente a mesma API pública para minimizar
/// alterações nas camadas superiores (`AuthViewModel`).
class AuthService {
  final DatabaseHelper _db = DatabaseHelper.instance;
  final SessionManager _session = SessionManager.instance;

  // Stream que avisa ChangeNotifiers sempre que o utilizador muda.
  final StreamController<UserModel?> _userController =
      StreamController<UserModel?>.broadcast();

  UserModel? _currentUser;

  Stream<UserModel?> get userStream => _userController.stream;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  /// Deve ser invocado no arranque da app (`main`).
  Future<void> bootstrap() async {
    final savedId = await _session.getCurrentUserId();
    if (savedId == null) {
      _emit(null);
      return;
    }
    final user = await _findById(savedId);
    _emit(user);
  }

  String _hash(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<UserModel?> _findById(String id) async {
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

  Future<UserModel?> _findByEmail(String email) async {
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

  Future<Result<UserModel>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final user = await _findByEmail(email);
      if (user == null) {
        return Result(error: CustomError('Utilizador não encontrado'));
      }
      if (user.passwordHash != _hash(password)) {
        return Result(error: CustomError('Email ou senha incorretos'));
      }

      await _session.setCurrentUserId(user.id);
      _emit(user);
      return Result(data: user);
    } catch (e) {
      return Result(error: CustomError('Falha ao iniciar sessão: $e'));
    }
  }

  Future<void> register(String name, String email, String password) async {
    final normalized = email.trim().toLowerCase();
    final existing = await _findByEmail(normalized);
    if (existing != null) {
      throw Exception('Já existe um utilizador com este email');
    }

    final user = UserModel(
      id: const Uuid().v4(),
      name: name.trim(),
      email: normalized,
      roles: [UserRole.patient],
      passwordHash: _hash(password),
    );

    final db = await _db.database;
    await db.insert('users', user.toMap());

    await _session.setCurrentUserId(user.id);
    _emit(user);
  }

  Future<void> signOut() async {
    await _session.clear();
    _emit(null);
  }

  Future<void> updateUserName(String name) async {
    final user = _currentUser;
    if (user == null) return;
    final db = await _db.database;
    await db.update(
      'users',
      {'name': name},
      where: 'id = ?',
      whereArgs: [user.id],
    );
    _emit(user.copyWith(name: name));
  }

  Future<void> deleteAccount(String email, String password) async {
    try {
      final user = await _findByEmail(email);
      if (user == null) {
        throw Exception('Utilizador não encontrado');
      }
      if (user.passwordHash != _hash(password)) {
        throw Exception('Email ou senha incorretos');
      }
      final db = await _db.database;
      await db.delete('users', where: 'id = ?', whereArgs: [user.id]);
      await signOut();
    } catch (e) {
      throw Exception('Falha ao apagar conta: $e');
    }
  }

  /// Sem servidor de email, esta operação local apenas valida que o email
  /// existe. A reposição efectiva é feita manualmente em
  /// [resetPasswordFromCurrentPassword].
  Future<void> resetPassword(String email) async {
    final user = await _findByEmail(email);
    if (user == null) {
      throw Exception('Email não está registado neste dispositivo');
    }
  }

  /// Copia a foto seleccionada para o directório de documentos da app e
  /// guarda o caminho local na tabela `users`. Antes ia para Firebase Storage.
  Future<String?> uploadProfilePicture(String photoPath) async {
    try {
      final user = _currentUser;
      if (user == null) {
        throw Exception('Sem sessão activa');
      }

      final docsDir = await getApplicationDocumentsDirectory();
      final profileDir = Directory(p.join(docsDir.path, 'profile_pictures'));
      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      final ext = p.extension(photoPath);
      final destination = p.join(profileDir.path, '${user.id}$ext');
      final saved = await File(photoPath).copy(destination);

      final db = await _db.database;
      await db.update(
        'users',
        {'image': saved.path},
        where: 'id = ?',
        whereArgs: [user.id],
      );

      _emit(user.copyWith(image: saved.path));
      return saved.path;
    } catch (e) {
      throw Exception('Erro ao guardar imagem: $e');
    }
  }

  Future<void> resetPasswordFromCurrentPassword(
    String currentPassword,
    String newPassword,
    String email,
  ) async {
    final user = await _findByEmail(email);
    if (user == null) {
      throw Exception('Utilizador não encontrado');
    }
    if (user.passwordHash != _hash(currentPassword)) {
      throw Exception('Senha actual incorrecta');
    }
    final db = await _db.database;
    await db.update(
      'users',
      {'password_hash': _hash(newPassword)},
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  void _emit(UserModel? user) {
    _currentUser = user;
    _userController.add(user);
  }
}
