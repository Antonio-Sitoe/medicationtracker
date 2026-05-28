import 'package:shared_preferences/shared_preferences.dart';

/// Mantém o ID do utilizador autenticado entre sessões.
/// Substitui o `FirebaseAuth.currentUser` que existia antes.
class SessionManager {
  static const _userIdKey = 'session_user_id';

  SessionManager._();
  static final SessionManager instance = SessionManager._();

  String? _cachedUserId;

  Future<String?> getCurrentUserId() async {
    if (_cachedUserId != null) return _cachedUserId;
    final prefs = await SharedPreferences.getInstance();
    _cachedUserId = prefs.getString(_userIdKey);
    return _cachedUserId;
  }

  Future<void> setCurrentUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    _cachedUserId = userId;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    _cachedUserId = null;
  }
}
