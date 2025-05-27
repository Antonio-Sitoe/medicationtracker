import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/viewModels/auth_view_model.dart';
import 'package:medicationtracker/views/widgets/form/button.dart';
import 'package:medicationtracker/views/widgets/form/input_email.dart';
import 'package:medicationtracker/views/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    setState(() => _isSubmitting = true);
    final email = _emailController.text;
    await auth.resetPassword(email);
    setState(() => _isSubmitting = false);
    if (!mounted) return;

    CustomSnackBar.showSuccess(
      context: context,
      title: 'E-mail enviado!',
      message: 'Verifique sua caixa de entrada para redefinir sua senha.',
    );

    await Future.delayed(const Duration(seconds: 2));
    context.push('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redefinir senha')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Esqueceu sua senha?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Digite seu e-mail para receber um link de redefinição',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            Form(
              key: _formKey,
              child: buildEmailField(
                _emailController,
                Theme.of(context).textTheme,
                'E-mail',
              ),
            ),
            const SizedBox(height: 32),

            buildButton(
              context: context,
              onPressed: _handleResetPassword,
              isLoading: _isSubmitting,
              label: 'Enviar link de redefinição',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
