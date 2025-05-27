enum UserRole { admin, patient, caregiver }

class UserModel {
  final String id;
  final String name;
  final String email;
  final List<UserRole> roles;
  final String? image;
  final String? caregiverId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    this.image,
    this.caregiverId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      roles:
          (json['roles'] as List<dynamic>)
              .map((e) => UserRole.values.byName(e))
              .toList(),
      image: json['image'],
      caregiverId: json['caregiverId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles.map((e) => e.name).toList(),
      'image': image,
      'caregiverId': caregiverId,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, roles: $roles, caregiverId: $caregiverId}';
  }
}
