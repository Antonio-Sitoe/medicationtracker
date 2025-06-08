mixin FrequencyFormatter {
  String formatFrequency(String frequency, List<int> specificDays) {
    const weekDays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    if (frequency == 'specific_days') {
      return specificDays
          .where((day) => day >= 0 && day < 7)
          .map((day) => weekDays[day])
          .join(', ');
    }
    const frequencyMap = {
      '1': 'Diário',
      '2': 'Diário',
      '3': 'Diário',
      '4': 'Diário',
    };
    return frequencyMap[frequency] ?? 'Quando necessário';
  }
}
