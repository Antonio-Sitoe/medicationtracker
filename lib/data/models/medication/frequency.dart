class Frequency {
  final String type;
  final int? intervalInDays;
  final List<int>? specificDays;

  Frequency({required this.type, this.intervalInDays, this.specificDays});

  factory Frequency.fromJson(Map<String, dynamic> json) {
    return Frequency(
      type: json['type'],
      intervalInDays: json['intervalInDays'],
      specificDays:
          (json['specificDays'] as List?)?.map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (intervalInDays != null) 'intervalInDays': intervalInDays,
      if (specificDays != null)
        'specificDays': specificDays!.map((value) => value).toList(),
    };
  }
}
