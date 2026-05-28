import 'package:flutter/material.dart';
import 'package:medicationtracker/data/models/caregiver.dart';
import 'package:medicationtracker/data/repositories/caregiver_repository.dart';

class PatientCaregiversScreen extends StatefulWidget {
  const PatientCaregiversScreen({super.key});

  @override
  State<PatientCaregiversScreen> createState() =>
      _PatientCaregiversScreenState();
}

class _PatientCaregiversScreenState extends State<PatientCaregiversScreen> {
  final CaregiverRepository _repo = CaregiverRepository();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  List<Caregiver> _caregivers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _repo.findMany();
      if (!mounted) return;
      setState(() {
        _caregivers = data;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _caregivers = [];
        _loading = false;
      });
    }
  }

  Future<void> _addCaregiver() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;

    final name = nameController.text.trim().isNotEmpty
        ? nameController.text.trim()
        : email.split('@').first;

    await _repo.create(
      name: name,
      email: email,
      relationship: relationshipController.text.trim().isEmpty
          ? null
          : relationshipController.text.trim(),
    );

    emailController.clear();
    relationshipController.clear();
    nameController.clear();

    if (mounted) Navigator.pop(context);
    await _load();
  }

  Future<void> _removeCaregiver(String id) async {
    await _repo.remove(id);
    await _load();
  }

  Widget _statusIcon(bool linked) {
    return Icon(
      linked ? Icons.check_circle : Icons.warning_amber_rounded,
      color: linked ? Colors.green : Colors.orange,
      size: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Cuidadores'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _caregivers.isEmpty
              ? const Center(
                  child: Text('Ainda não adicionou nenhum cuidador.'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _caregivers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final c = _caregivers[index];
                    return _buildCaregiverCard(c);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        label: const Text('Adicionar Cuidador'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCaregiverCard(Caregiver c) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[300],
                child: Text(
                  c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      c.email,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    if (c.relationship != null && c.relationship!.isNotEmpty)
                      Text(
                        c.relationship!,
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              _statusIcon(c.isLinked),
            ],
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _removeCaregiver(c.id),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'Remover',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Novo Cuidador',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: relationshipController,
              decoration: const InputDecoration(labelText: 'Parentesco'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCaregiver,
              child: const Text('Vincular Cuidador'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    relationshipController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
