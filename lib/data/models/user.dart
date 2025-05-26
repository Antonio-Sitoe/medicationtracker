enum UserRole { admin, patient, caregiver }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profilePictureUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.patient,
    this.profilePictureUrl,
  });

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, role: $role, profilePictureUrl: $profilePictureUrl}';
  }
}
