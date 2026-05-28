import 'package:flutter/material.dart';
import 'package:medicationtracker/data/models/reminder.dart';
import 'package:medicationtracker/viewModels/reminder_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedPeriod = '7days';
  bool showPeriodPicker = false;

  List<Reminder> _reminders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final vm = Provider.of<ReminderViewModel>(context, listen: false);
    final list = await vm.findMany();
    if (!mounted) return;
    setState(() {
      _reminders = list;
      _loading = false;
    });
  }

  Map<String, dynamic> _calculateAdherence() {
    final now = DateTime.now();
    final startDate = selectedPeriod == '7days'
        ? now.subtract(const Duration(days: 7))
        : now.subtract(const Duration(days: 30));

    final filtered = _reminders.where((r) {
      final date = r.createdAt;
      return date.isAfter(startDate) && date.isBefore(now);
    }).toList();

    final total = filtered.length;
    final taken = filtered.where((r) => r.actionTaken == 'take').length;
    final missed = filtered.where((r) => r.actionTaken == 'dismissed').length;

    return {
      'adherenceRate': total > 0 ? (taken / total) * 100 : 0.0,
      'total': total,
      'taken': taken,
      'missed': missed,
    };
  }

  String _periodLabel(String period) {
    return switch (period) {
      '7days' => 'Últimos 7 dias',
      '30days' => 'Últimos 30 dias',
      'custom' => 'Personalizado',
      _ => 'Desconhecido',
    };
  }

  void _handleShare(Map<String, dynamic> stats) async {
    final rate = (stats['adherenceRate'] as double).round();
    final text = '''
Relatório de Medicamentos

Período: ${_periodLabel(selectedPeriod)}
Taxa de adesão: $rate%
Doses tomadas: ${stats['taken']}
Doses perdidas: ${stats['missed']}
Total de doses: ${stats['total']}
''';
    await Share.share(text, subject: 'Relatório de Medicamentos');
  }

  @override
  Widget build(BuildContext context) {
    final stats = _calculateAdherence();
    final rate = (stats['adherenceRate'] as double).round();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Text(
                        'Período',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => setState(
                          () => showPeriodPicker = !showPeriodPicker,
                        ),
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
                              Expanded(child: Text(_periodLabel(selectedPeriod))),
                              const Icon(Icons.expand_more),
                            ],
                          ),
                        ),
                      ),
                      if (showPeriodPicker)
                        Column(
                          children: ['7days', '30days'].map((period) {
                            final isSelected = selectedPeriod == period;
                            return ListTile(
                              title: Text(
                                _periodLabel(period),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.deepPurple
                                      : Colors.black,
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.deepPurple,
                                    )
                                  : null,
                              onTap: () => setState(() {
                                selectedPeriod = period;
                                showPeriodPicker = false;
                              }),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(blurRadius: 6, color: Colors.black12),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$rate%',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _actionButton(
                            Icons.share,
                            'Compartilhar',
                            () => _handleShare(stats),
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
            color: Colors.deepPurple.withValues(alpha: 0.05),
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
