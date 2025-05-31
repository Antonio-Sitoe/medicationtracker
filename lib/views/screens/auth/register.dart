import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:medicationtracker/views/widgets/_show_error_dialog.dart';
import 'package:medicationtracker/views/widgets/build_header.dart';
import 'package:medicationtracker/views/widgets/KeyboardAvoidingView.dart';
import 'package:medicationtracker/views/widgets/form/button.dart';
import 'package:medicationtracker/views/widgets/form/input.dart';
import 'package:medicationtracker/views/widgets/form/input_email.dart';
import 'package:medicationtracker/views/widgets/form/input_password.dart';
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
      showErrorDialog(context, 'As senhas não coincidem.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await authViewModel.register(
        email: _emailController.text.trim(),
        username: _nameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
    } catch (error) {
      if (!mounted) return;
      showErrorDialog(
        context,
        'Ocorreu um erro durante o cadastro. Tente novamente.',
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
          behavior: KeyboardAvoidingBehavior.height,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader(
                    title: 'Criar Conta',
                    subtitle: 'Preencha seus dados para criar uma conta',
                    onBack: () => GoRouter.of(context).push('/login'),
                    backIcon: Icons.arrow_back_ios,
                  ),
                  const SizedBox(height: 32),
                  buildInputText(_nameController, textTheme, 'Nome completo'),
                  const SizedBox(height: 16),
                  buildEmailField(_emailController, textTheme, 'E-mail'),
                  const SizedBox(height: 16),
                  buildPasswordField(
                    controller: _passwordController,
                    textTheme: textTheme,
                    label: 'Senha',
                    showPassword: _showPassword,
                    onPressed:
                        () => setState(() => _showPassword = !_showPassword),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, digite sua senha';
                      }
                      if (value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  buildPasswordField(
                    controller: _confirmPasswordController,
                    textTheme: textTheme,
                    label: 'Confirmar senha',
                    showPassword: _showConfirmPassword,
                    onPressed:
                        () => setState(
                          () => _showConfirmPassword = !_showConfirmPassword,
                        ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme sua senha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  buildButton(
                    label: 'Cadastrar',
                    context: context,
                    onPressed: _handleRegister,
                    isLoading: _isSubmitting,
                  ),
                  const SizedBox(height: 32),
                  Row(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
