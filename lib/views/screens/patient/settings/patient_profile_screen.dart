import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:medicationtracker/views/widgets/form/button.dart';
import 'package:medicationtracker/views/widgets/form/input.dart';

class ProfileSettingsScreen extends StatefulWidget {
  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: 'João da Silva',
  );
  String? photoUri;
  Future<void> _handleSelectProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => photoUri = pickedFile.path);
    }
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: _handleSelectProfilePicture,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            photoUri != null
                                ? FileImage(File(photoUri!))
                                : null,
                        child:
                            photoUri == null
                                ? const Text(
                                  'Selecionar\nFoto',
                                  textAlign: TextAlign.center,
                                )
                                : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  buildInputText(
                    _nameController,
                    Theme.of(context).textTheme,
                    'Nome completo',
                  ),
                  const SizedBox(height: 100),
                ],
              ),

              buildButton(
                label: 'Gravar',
                context: context,
                onPressed: () {},
                isLoading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
