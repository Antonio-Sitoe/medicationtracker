class Medication {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final List<String> times;
  final DateTime startDate;
  final DateTime? endDate;
  final bool active;
  final String? instructions;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.startDate,
    this.endDate,
    required this.active,
    this.instructions,
  });
}
