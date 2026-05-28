import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/core/routes/app_named_routes.dart';
import 'package:medicationtracker/data/models/userModel.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:provider/provider.dart';

/// Tela onde o utilizador escolhe se vai usar a app como paciente ou cuidador.
/// Os "perfis" disponíveis derivam dos roles guardados na tabela SQLite `users`.
class ProfileSelection extends StatelessWidget {
  const ProfileSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Provider.of<AuthViewModel>(context);
    final user = auth.currentUser;

    final availableRoles = user == null || user.roles.isEmpty
        ? <UserRole>[UserRole.patient]
        : user.roles;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Selecionar Perfil',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: AppFontSize.xxl,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Selecione como pretende utilizar a aplicação',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 25,
                    child: IconButton(
                      tooltip: 'Sair',
                      onPressed: () async {
                        await auth.signOut();
                        if (context.mounted) {
                          GoRouter.of(context).go(AppNamedRoutes.login);
                        }
                      },
                      icon: const Icon(Icons.logout, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 48),
                  itemCount: availableRoles.length,
                  itemBuilder: (context, index) {
                    final role = availableRoles[index];
                    return _ProfileCard(
                      role: role,
                      userName: user?.name ?? 'Utilizador',
                      photoUrl: user?.image,
                      onTap: () {
                        // Por enquanto, apenas paciente tem fluxo completo.
                        // Cuidador também aterra na home; a separação por role
                        // pode ser estendida mais tarde.
                        GoRouter.of(context).go(AppNamedRoutes.patientTabsHome);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserRole role;
  final String userName;
  final String? photoUrl;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.role,
    required this.userName,
    required this.onTap,
    this.photoUrl,
  });

  String get _label {
    switch (role) {
      case UserRole.patient:
        return 'Paciente';
      case UserRole.caregiver:
        return 'Cuidador';
      case UserRole.admin:
        return 'Administrador';
    }
  }

  IconData get _icon {
    switch (role) {
      case UserRole.patient:
        return Icons.person;
      case UserRole.caregiver:
        return Icons.health_and_safety;
      case UserRole.admin:
        return Icons.shield;
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? avatar;
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      avatar = photoUrl!.startsWith('http')
          ? NetworkImage(photoUrl!) as ImageProvider
          : FileImage(File(photoUrl!));
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.background,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              if (avatar != null)
                CircleAvatar(radius: 40, backgroundImage: avatar)
              else
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Icon(_icon, size: 36, color: Colors.white),
                ),
              const SizedBox(height: 16),
              Text(
                _label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
