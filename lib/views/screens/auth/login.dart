import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:medicationtracker/views/widgets/_show_error_dialog.dart';
import 'package:medicationtracker/views/widgets/form/button.dart';
import 'package:medicationtracker/views/widgets/form/input_email.dart';
import 'package:medicationtracker/views/widgets/form/input_password.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isSubmitting = false;
  String? errorMessage = "";

  Future<void> _handleLogin() async {
    final auth = Provider.of<AuthViewModel>(context, listen: false);

    final email = _emailController.text;
    final password = _passwordController.text;
    if (!_formKey.currentState!.validate()) return;

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await auth.signIn(email, password);

      if (!result.isSuccess) {
        setState(() {
          errorMessage = result.error?.message ?? "";
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage =
            "Ocorreu um erro durante o registo, verifique as credencias e Tente novamente.";
      });
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _createNewAccount(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Não possui uma conta?', style: theme.textTheme.bodyMedium),
        TextButton(
          onPressed: () => context.push('/register'),
          child: Text(
            'Cadastre-se',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final isLoading = _isSubmitting;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20), // Espaço no topo
                            Text(
                              'Bem-vindo de volta',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: AppFontSize.xxl,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Entre com suas credenciais para acessar sua conta',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.gray500,
                              ),
                            ),
                            const SizedBox(height: 32),
                            buildEmailField(
                              _emailController,
                              theme.textTheme,
                              'E-mail',
                            ),
                            const SizedBox(height: 20),

                            buildPasswordField(
                              controller: _passwordController,
                              textTheme: theme.textTheme,
                              label: 'Senha',
                              showPassword: _showPassword,
                              onPressed:
                                  () => setState(
                                    () => _showPassword = !_showPassword,
                                  ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, digite sua senha';
                                }

                                return null;
                              },
                            ),
                            errorMessage != null && errorMessage!.isNotEmpty
                                ? Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed:
                                    () => context.push('/forgot-password'),
                                child: Text(
                                  'Esqueceu a senha?',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            buildButton(
                              label: 'Entrar',
                              context: context,
                              onPressed: _handleLogin,
                              isLoading: isLoading,
                            ),
                            const SizedBox(height: 24),
                            _createNewAccount(theme),
                            const SizedBox(height: 20), // Espaço no final
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
