import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedPeriod = '7days';
  bool showPeriodPicker = false;

  final List<Map<String, dynamic>> medicationSchedules =
      []; // mock or load from provider

  Map<String, dynamic> calculateAdherence() {
    final now = DateTime.now();
    final startDate =
        selectedPeriod == '7days'
            ? now.subtract(const Duration(days: 7))
            : now.subtract(const Duration(days: 30));

    final filtered =
        medicationSchedules.where((schedule) {
          final date = DateTime.parse(schedule['scheduledTime']);
          return date.isAfter(startDate) && date.isBefore(now);
        }).toList();

    final total = filtered.length;
    final taken = filtered.where((s) => s['status'] == 'taken').length;
    final missed = filtered.where((s) => s['status'] == 'missed').length;

    return {
      'adherenceRate': total > 0 ? (taken / total) * 100 : 0,
      'total': total,
      'taken': taken,
      'missed': missed,
    };
  }

  String getPeriodLabel(String period) {
    return switch (period) {
      '7days' => 'Últimos 7 dias',
      '30days' => 'Últimos 30 dias',
      'custom' => 'Personalizado',
      _ => 'Desconhecido',
    };
  }

  void handleShare(Map<String, dynamic> stats) async {
    final text = '''
Relatório de Medicamentos

Período: ${getPeriodLabel(selectedPeriod)}
Taxa de adesão: ${stats['adherenceRate'].round()}%
Doses tomadas: ${stats['taken']}
Doses perdidas: ${stats['missed']}
Total de doses: ${stats['total']}
''';
    await Share.share(text, subject: 'Relatório de Medicamentos');
  }

  @override
  Widget build(BuildContext context) {
    final stats = calculateAdherence();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Relatórios',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Period Selector
                Text('Período', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap:
                      () =>
                          setState(() => showPeriodPicker = !showPeriodPicker),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(getPeriodLabel(selectedPeriod))),
                        const Icon(Icons.expand_more),
                      ],
                    ),
                  ),
                ),
                if (showPeriodPicker)
                  Column(
                    children:
                        ['7days', '30days', 'custom'].map((period) {
                          final isSelected = selectedPeriod == period;
                          return ListTile(
                            title: Text(
                              getPeriodLabel(period),
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.deepPurple
                                        : Colors.black,
                              ),
                            ),
                            trailing:
                                isSelected
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.deepPurple,
                                    )
                                    : null,
                            onTap:
                                () => setState(() {
                                  selectedPeriod = period;
                                  showPeriodPicker = false;
                                }),
                          );
                        }).toList(),
                  ),

                const SizedBox(height: 20),

                // Adherence Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(blurRadius: 6, color: Colors.black12),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${stats['adherenceRate'].round()}%',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Taxa de adesão ao tratamento'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statColumn('Doses tomadas', stats['taken']),
                          _statColumn('Doses perdidas', stats['missed']),
                          _statColumn('Total de doses', stats['total']),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton(Icons.picture_as_pdf, 'Exportar PDF', () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Função de exportar em desenvolvimento',
                          ),
                        ),
                      );
                    }),
                    _actionButton(
                      Icons.share,
                      'Compartilhar',
                      () => handleShare(stats),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statColumn(String label, int value) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.deepPurple),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.deepPurple)),
            ],
          ),
        ),
      ),
    );
  }
}
