enum FrequencyType { daily, interval, specificDays }

enum Weekday { mon, tue, wed, thu, fri, sat, sun }

class Frequency {
  final FrequencyType type;
  final int? intervalInDays;
  final List<Weekday>? specificDays;

  Frequency({required this.type, this.intervalInDays, this.specificDays});

  factory Frequency.fromJson(Map<String, dynamic> json) {
    return Frequency(
      type: FrequencyType.values.byName(json['type']),
      intervalInDays: json['intervalInDays'],
      specificDays:
          (json['specificDays'] as List?)
              ?.map((e) => Weekday.values.byName(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      if (intervalInDays != null) 'intervalInDays': intervalInDays,
      if (specificDays != null)
        'specificDays': specificDays!.map((e) => e.name).toList(),
    };
  }
}
