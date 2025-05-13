import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';

final List<Map<String, dynamic>> profiles = [
  {
    "id": '1',
    "name": 'Meu perfil',
    "age": 72,
    "type": 'patient',
    "photoUrl":
        'https://images.pexels.com/photos/834863/pexels-photo-834863.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  },
  {
    "id": '3',
    "name": 'Cuidador',
    "age": 42,
    "type": 'caregiver',
    "photoUrl":
        'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  },
];

class ProfileSelection extends StatelessWidget {
  const ProfileSelection({super.key});

  VoidCallback get onLogout => () {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                        const SizedBox(height: 20), // Espaço no topo
                        Text(
                          'Selecionar Perfil',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: AppFontSize.xxl,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Selecione um perfil para continuar",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 25,
                    child: IconButton(
                      onPressed: onLogout,
                      icon: const Icon(Icons.logout, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 48),
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];

                    return GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push('/patient-tabs/home');
                      },
                      child: Card(
                        color: AppColors.background,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              profile['photoUrl'] != null
                                  ? CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                      profile['photoUrl'],
                                    ),
                                  )
                                  : CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.blue[100],
                                    child: Text(
                                      profile['name'][index],
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: AppFontFamily.regular,
                                      ),
                                    ),
                                  ),
                              const SizedBox(height: 20),
                              Text(
                                profile['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
