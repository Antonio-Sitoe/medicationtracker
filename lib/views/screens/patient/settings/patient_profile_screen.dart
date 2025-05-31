import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'dart:io';

import 'package:medicationtracker/views/widgets/form/button.dart';
import 'package:medicationtracker/views/widgets/form/input.dart';
import 'package:medicationtracker/views/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  String? photoUri;
  Future<void> _handleSelectProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => photoUri = pickedFile.path);
    }
  }

  Future<void> handleSubmit() async {
    setState(() => isLoading = true);

    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final name = _nameController.text;

    if (photoUri != null) {
      await auth.uploadProfileImage(photoUri!);
    }
    if (name.isNotEmpty) {
      await auth.currentUser?.updateDisplayName(name);
    }

    await auth.reloadUser();

    setState(() {
      photoUri = auth.currentUser?.photoURL;
      _nameController.text = auth.currentUser?.displayName ?? '';
    });

    CustomSnackBar.showSuccess(
      context: context,
      title: "Dados atualizados com sucesso",
      message: '',
    );

    setState(() => isLoading = false);
  }

  @override
  initState() {
    super.initState();
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final user = auth.currentUser?.displayName;

    _nameController.text = user ?? '';
    photoUri = auth.currentUser?.photoURL;

    print(photoUri);
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
                                ? photoUri!.startsWith('http')
                                    ? NetworkImage(photoUri!) as ImageProvider
                                    : FileImage(File(photoUri!))
                                : null,
                        child:
                            photoUri == null
                                ? const Text(
                                  'Selecionar\nFoto',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppFontFamily.regular,
                                    fontSize: 13,
                                  ),
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
                onPressed: handleSubmit,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
