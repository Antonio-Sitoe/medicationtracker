class Caregiver {
  final String id;
  final String patientId;
  final String name;
  final String email;
  final String? relationship;
  final String? photo;
  final bool isLinked;
  final DateTime createdAt;

  Caregiver({
    required this.id,
    required this.patientId,
    required this.name,
    required this.email,
    this.relationship,
    this.photo,
    this.isLinked = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'patient_id': patientId,
        'name': name,
        'email': email,
        'relationship': relationship,
        'photo': photo,
        'is_linked': isLinked ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory Caregiver.fromMap(Map<String, dynamic> map) => Caregiver(
        id: map['id'] as String,
        patientId: map['patient_id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        relationship: map['relationship'] as String?,
        photo: map['photo'] as String?,
        isLinked: ((map['is_linked'] as int?) ?? 0) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  Caregiver copyWith({
    String? id,
    String? patientId,
    String? name,
    String? email,
    String? relationship,
    String? photo,
    bool? isLinked,
    DateTime? createdAt,
  }) {
    return Caregiver(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      email: email ?? this.email,
      relationship: relationship ?? this.relationship,
      photo: photo ?? this.photo,
      isLinked: isLinked ?? this.isLinked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
