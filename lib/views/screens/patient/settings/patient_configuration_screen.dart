import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/core/services/notifications/notification_service.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SettingsView extends StatefulWidget {
  final VoidCallback onLogout;
  final String? userName;
  final String? userType;
  final String? photoUrl;

  const _SettingsView({
    required this.onLogout,
    this.userName,
    this.userType,
    this.photoUrl,
  });

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  static const _prefKey = 'notifications_enabled';
  bool _notificationsEnabled = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _notificationsEnabled = prefs.getBool(_prefKey) ?? true;
      _loaded = true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);

    if (!value) {
      // Ao desligar, cancelamos todos os lembretes agendados.
      await NotificationService().cancelAllReminders();
    } else {
      // Ao religar, reagendamos os existentes.
      await NotificationService().reScheduleAllReminders();
    }

    if (!mounted) return;
    setState(() => _notificationsEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Configurações',
                  style: TextStyle(
                    fontSize: AppFontSize.xxxl,
                    fontFamily: AppFontFamily.bold,
                    color: AppColors.text,
                  ),
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
                    value: _notificationsEnabled,
                    onChanged: _toggleNotifications,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSettingGroupTitle('Perfil e Conta'),
                  _buildNavigationTile(
                    icon: Icons.person,
                    title: 'Editar Perfil',
                    subtitle: 'Nome e foto',
                    onTap: () =>
                        GoRouter.of(context).push('/patient-tabs/settings/profile'),
                  ),
                  _buildNavigationTile(
                    icon: Icons.group,
                    title: 'Cuidadores',
                    subtitle: 'Gerir cuidadores associados',
                    onTap: () => GoRouter.of(context)
                        .push('/patient-tabs/settings/caregiver'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSettingGroupTitle('Sobre'),
                  _buildNavigationTile(
                    icon: Icons.info,
                    title: 'Sobre o App',
                    subtitle: 'Versão 1.0.0 — base de dados local',
                    onTap: () => _showAboutDialog(context),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                      backgroundColor: AppColors.white,
                    ),
                    onPressed: widget.onLogout,
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: const Text(
                      'Sair da Conta',
                      style: TextStyle(
                        color: AppColors.error,
                        fontFamily: AppFontFamily.semibold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'MedicationTracker',
      applicationVersion: '1.0.0',
      applicationLegalese:
          'Aplicação local para gestão de medicação. '
          'Todos os dados ficam armazenados no dispositivo (SQLite).',
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    ImageProvider? avatar;
    final url = widget.photoUrl;
    if (url != null && url.isNotEmpty) {
      avatar = url.startsWith('http')
          ? NetworkImage(url) as ImageProvider
          : FileImage(File(url));
    }

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
            backgroundImage: avatar,
            child: avatar == null
                ? Text(
                    widget.userName != null && widget.userName!.isNotEmpty
                        ? widget.userName![0].toUpperCase()
                        : '?',
                    style: const TextStyle(
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
                  widget.userName ?? 'Utilizador',
                  style: const TextStyle(
                    fontSize: AppFontSize.lg,
                    fontFamily: AppFontFamily.semibold,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  widget.userType == 'caregiver' ? 'Cuidador' : 'Paciente',
                  style: const TextStyle(
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
            child: const Text(
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
        style: const TextStyle(
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
          backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
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
          backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
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
    final auth = Provider.of<AuthViewModel>(context);
    final user = auth.currentUser;
    final userType = user != null && user.roles.isNotEmpty
        ? user.roles.first.name
        : 'patient';

    return _SettingsView(
      onLogout: () async {
        await auth.signOut();
      },
      userName: user?.displayName ?? '---',
      userType: userType,
      photoUrl: user?.image,
    );
  }
}
