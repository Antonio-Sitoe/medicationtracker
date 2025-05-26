import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isSubmitting = false;

  Future<void> _handleRegister() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('As senhas não coincidem.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await authViewModel.register(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;
    } catch (error) {
      if (!mounted) return;
      _showErrorDialog('Ocorreu um erro durante o cadastro. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Erro'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: KeyboardAvoidingView(
          behavior:
              Platform.isIOS
                  ? KeyboardAvoidingBehavior.padding
                  : KeyboardAvoidingBehavior.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, textTheme),
                  const SizedBox(height: 32),
                  _buildNameField(textTheme),
                  const SizedBox(height: 16),
                  _buildEmailField(textTheme),
                  const SizedBox(height: 16),
                  _buildPasswordField(textTheme),
                  const SizedBox(height: 16),
                  _buildConfirmPasswordField(textTheme),
                  const SizedBox(height: 24),
                  _buildRegisterButton(colorScheme, textTheme),
                  const SizedBox(height: 32),
                  _buildFooter(context, colorScheme, textTheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.push('/login'),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey[200],
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Criar Conta',
          style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Preencha seus dados para criar uma conta',
          style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildNameField(TextTheme textTheme) {
    return TextFormField(
      controller: _nameController,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: AppFontFamily.regular,
      ),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: const Icon(Icons.person_outline),
        labelText: 'Nome completo',
        labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, digite seu nome';
        }
        return null;
      },
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildEmailField(TextTheme textTheme) {
    return TextFormField(
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: AppFontFamily.regular,
      ),
      controller: _emailController,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: const Icon(Icons.email_outlined),
        labelText: 'E-mail',
        labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, digite seu e-mail';
        }
        if (!value.contains('@')) {
          return 'Digite um e-mail válido';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
    );
  }

  Widget _buildPasswordField(TextTheme textTheme) {
    return TextFormField(
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: AppFontFamily.regular,
      ),
      controller: _passwordController,
      obscureText: !_showPassword,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: const Icon(Icons.lock_outline),
        labelText: 'Senha',
        labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[600],
          ),
          onPressed: () => setState(() => _showPassword = !_showPassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, digite sua senha';
        }
        if (value.length < 6) {
          return 'A senha deve ter pelo menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(TextTheme textTheme) {
    return TextFormField(
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: AppFontFamily.regular,
      ),
      controller: _confirmPasswordController,
      obscureText: !_showConfirmPassword,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        prefixIcon: const Icon(Icons.lock_outline),
        labelText: 'Confirmar senha',
        labelStyle: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        suffixIcon: IconButton(
          icon: Icon(
            _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[600],
          ),
          onPressed:
              () =>
                  setState(() => _showConfirmPassword = !_showConfirmPassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, confirme sua senha';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton(ColorScheme colorScheme, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            _isSubmitting
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                  'Cadastrar',
                  style: textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Já possui uma conta?', style: textTheme.bodyMedium),
        TextButton(
          onPressed: () => context.push('/login'),
          child: Text(
            'Entrar',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class KeyboardAvoidingView extends StatelessWidget {
  final KeyboardAvoidingBehavior behavior;
  final Widget child;

  const KeyboardAvoidingView({
    super.key,
    required this.behavior,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    switch (behavior) {
      case KeyboardAvoidingBehavior.padding:
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: child,
        );
      case KeyboardAvoidingBehavior.height:
      default:
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewInsets.bottom,
            ),
            child: child,
          ),
        );
    }
  }
}

enum KeyboardAvoidingBehavior { padding, height }
