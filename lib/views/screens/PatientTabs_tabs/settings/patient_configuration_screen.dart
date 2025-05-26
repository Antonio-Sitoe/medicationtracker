import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/core/services/auth.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final VoidCallback onLogout;
  final String? userName;
  final String? userType;
  final String? photoUrl;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
    required this.onLogout,
    this.userName,
    this.userType,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Configurações',
                style: TextStyle(
                  fontSize: AppFontSize.xxxl,
                  fontFamily: AppFontFamily.bold,
                  color: AppColors.text,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                children: [
                  _buildProfileHeader(context),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSettingGroupTitle('Configurações Gerais'),
                  _buildSwitchTile(
                    icon: Icons.notifications,
                    title: 'Notificações',
                    subtitle: 'Lembretes de medicamentos',
                    value: true,
                    onChanged: (_) {},
                  ),
                  _buildSwitchTile(
                    icon: Icons.dark_mode,
                    title: 'Tema Escuro',
                    subtitle: 'Mudar aparência do app',
                    value: isDarkMode,
                    onChanged: (_) => toggleTheme(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSettingGroupTitle('Perfil e Conta'),
                  _buildNavigationTile(
                    icon: Icons.group,
                    title: 'Gerenciar Perfis',
                    subtitle: 'Pacientes e cuidadores',
                    onTap: () {
                      GoRouter.of(
                        context,
                      ).push('/patient-tabs/settings/caregiver');
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSettingGroupTitle('Sobre'),
                  _buildNavigationTile(
                    icon: Icons.info,
                    title: 'Sobre o App',
                    subtitle: 'Versão 1.0.0',
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      side: BorderSide(color: AppColors.error.withOpacity(0.3)),
                      backgroundColor: AppColors.white,
                    ),
                    onPressed: onLogout,
                    icon: Icon(Icons.logout, color: AppColors.error),
                    label: Text(
                      'Sair da Conta',
                      style: TextStyle(
                        color: AppColors.error,
                        fontFamily: AppFontFamily.semibold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.primaryLight,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
            child:
                photoUrl == null
                    ? Text(
                      userName != null && userName!.isNotEmpty
                          ? userName![0]
                          : '?',
                      style: TextStyle(
                        fontSize: AppFontSize.xl,
                        fontFamily: AppFontFamily.bold,
                        color: AppColors.white,
                      ),
                    )
                    : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? 'Usuário',
                  style: TextStyle(
                    fontSize: AppFontSize.lg,
                    fontFamily: AppFontFamily.semibold,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  userType == 'caregiver' ? 'Cuidador' : 'Paciente',
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontFamily: AppFontFamily.regular,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              GoRouter.of(context).push('/patient-tabs/settings/profile');
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.gray100,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Editar',
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontFamily: AppFontFamily.medium,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppFontSize.md,
          fontFamily: AppFontFamily.semibold,
          color: AppColors.textLight,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight.withOpacity(0.2),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryLight.withOpacity(0.2),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: AppColors.gray500),
        onTap: onTap,
      ),
    );
  }
}

class PatientConfigurationScreen extends StatelessWidget {
  const PatientConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    return SettingsScreen(
      isDarkMode: true,
      toggleTheme: () => print('Trocar tema'),
      onLogout: () async {
        final auth = Provider.of<AuthViewModel>(context, listen: false);
        await auth.signOut();
      },
      userName: auth.currentUser?.email.toString() ?? 'Tony',
      userType: 'caregiver',
      photoUrl: null,
    );
  }
}
