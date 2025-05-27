import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Cuidador {
  final String id;
  final String nome;
  final String email;
  final String? foto;
  final bool criado;
  final String parentesco;

  Cuidador({
    required this.id,
    required this.nome,
    required this.email,
    this.foto,
    required this.criado,
    required this.parentesco,
  });
}

class PatientCaregiversScreen extends StatefulWidget {
  const PatientCaregiversScreen({super.key});

  @override
  State<PatientCaregiversScreen> createState() =>
      _PatientCaregiversScreenState();
}

class _PatientCaregiversScreenState extends State<PatientCaregiversScreen> {
  final List<Cuidador> _cuidadores = [
    Cuidador(
      id: '1',
      nome: 'Maria Oliveira',
      email: 'maria@gmail.com',
      foto: 'https://randomuser.me/api/portraits/men/22.jpg',
      criado: true,
      parentesco: 'Filha',
    ),
    Cuidador(
      id: '2',
      nome: 'Carlos Souza',
      email: 'carlos@email.com',
      foto: 'https://randomuser.me/api/portraits/men/22.jpg',
      criado: false,
      parentesco: 'Irmão',
    ),
  ];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController parentescoController = TextEditingController();
  bool showModal = false;

  void _addCuidador() {
    setState(() {
      _cuidadores.add(
        Cuidador(
          id: DateTime.now().toString(),
          nome: emailController.text.split('@')[0],
          email: emailController.text,
          foto: null,
          criado: false,
          parentesco: parentescoController.text,
        ),
      );
    });

    emailController.clear();
    parentescoController.clear();
    Navigator.pop(context);
  }

  void _removerCuidador(String id) {
    setState(() {
      _cuidadores.removeWhere((c) => c.id == id);
    });
  }

  Widget _statusIcon(bool criado) {
    return Icon(
      criado ? LucideIcons.checkCircle : LucideIcons.alertTriangle,
      color: criado ? Colors.green : Colors.orange,
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _cuidadores.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final c = _cuidadores[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          c.foto != null ? NetworkImage(c.foto!) : null,
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            c.email,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            c.parentesco,
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _statusIcon(c.criado),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _removerCuidador(c.id),
                  icon: const Icon(LucideIcons.trash2, color: Colors.red),
                  label: const Text(
                    'Remover',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder:
                (_) => Padding(
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: parentescoController,
                        decoration: const InputDecoration(
                          labelText: 'Parentesco',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addCuidador,
                        child: const Text('Vincular Cuidador'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ),
          );
        },
        label: const Text('Adicionar Cuidador'),
        icon: const Icon(LucideIcons.plus),
      ),
    );
  }
}
