import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController nomeController = TextEditingController(
    text: 'João da Silva',
  );
  final TextEditingController idadeController = TextEditingController(
    text: '65',
  );
  final TextEditingController emailCuidadorController = TextEditingController();

  String? fotoUri;

  Future<void> handleSelecionarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => fotoUri = pickedFile.path);
    }
  }

  void handleVincularCuidador() {
    final email = emailCuidadorController.text.trim();
    if (email.isEmpty) return;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Solicitação enviada'),
            content: Text('Convite enviado para: $email'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
    emailCuidadorController.clear();
  }

  void handleRemoverCuidador() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Cuidador removido'),
            content: const Text('O cuidador foi desvinculado com sucesso.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void handleSair() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Configurações do Perfil',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: handleSelecionarFoto,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        fotoUri != null ? FileImage(File(fotoUri!)) : null,
                    child:
                        fotoUri == null
                            ? const Text(
                              'Selecionar\nFoto',
                              textAlign: TextAlign.center,
                            )
                            : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: handleSair,
                icon: const Icon(Icons.logout),
                label: const Text('Apagar da Conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
