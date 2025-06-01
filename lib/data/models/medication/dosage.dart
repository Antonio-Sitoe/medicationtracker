enum DosageUnit { mg, ml, g, ui }

class Dosage {
  final double quantity;
  final DosageUnit unit;

  Dosage({required this.quantity, required this.unit});

  factory Dosage.fromJson(Map<String, dynamic> json) {
    return Dosage(
      quantity: (json['quantity'] as num).toDouble(),
      unit: DosageUnit.values.firstWhere(
        (e) => e.toString().split('.').last == json['unit'],
        orElse: () => DosageUnit.mg,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'quantity': quantity, 'unit': unit.toString().split('.').last};
  }
}
