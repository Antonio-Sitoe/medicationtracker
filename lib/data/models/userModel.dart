enum UserRole { admin, patient, caregiver }

class UserModel {
  final String id;
  final String name;
  final String email;
  final List<UserRole> roles;
  final String? image;
  final String? caregiverId;

  /// Apenas usado na criação/login. Não é persistido em memória depois da auth.
  final String? passwordHash;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    this.image,
    this.caregiverId,
    this.passwordHash,
  });

  /// Compatibilidade com o uso antigo do `User` do Firebase em algumas telas.
  String get displayName => name;
  String get uid => id;

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    List<UserRole>? roles,
    String? image,
    String? caregiverId,
    String? passwordHash,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      image: image ?? this.image,
      caregiverId: caregiverId ?? this.caregiverId,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }

  /// Constrói a partir de uma linha da tabela `users` em SQLite.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final rolesRaw = (map['roles'] as String?) ?? 'patient';
    final roles = rolesRaw
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .map((e) => UserRole.values.byName(e.trim()))
        .toList();

    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      roles: roles.isEmpty ? [UserRole.patient] : roles,
      image: map['image'] as String?,
      caregiverId: map['caregiver_id'] as String?,
      passwordHash: map['password_hash'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles.map((r) => r.name).join(','),
      'image': image,
      'caregiver_id': caregiverId,
      if (passwordHash != null) 'password_hash': passwordHash,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, roles: $roles}';
  }
}
