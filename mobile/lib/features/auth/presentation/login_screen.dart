import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/bramble_text_field.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'noor@example.com');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).login(email, password);
    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      final error = ref.read(authControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Brand Logo B badge
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: BrambleColors.primaryOrange,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x382E2B25),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'B',
                    style: BrambleTypography.displayLarge(color: const Color(0xFFFFF2EB)),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'Welcome back',
                style: BrambleTypography.displayLarge(color: BrambleColors.creamInk),
              ),
              const SizedBox(height: 8),
              Text(
                'Your shelf, notes and streak are waiting where you left them.',
                style: BrambleTypography.bodyMedium(color: BrambleColors.creamSubdued),
              ),
              const SizedBox(height: 28),
              BrambleTextField(
                label: 'EMAIL',
                placeholder: 'noor@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              BrambleTextField(
                label: 'PASSWORD',
                placeholder: '••••••••',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Demo account: noor@example.com / password123')),
                  );
                },
                child: Text(
                  'Forgot password',
                  style: BrambleTypography.bodySmall(
                    color: BrambleColors.primaryOrangeDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              BrambleButton(
                text: 'Log in',
                isLoading: isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: BrambleColors.creamInk.withOpacity(0.14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'OR',
                      style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: BrambleColors.creamInk.withOpacity(0.14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BrambleButton(
                text: 'Continue with Apple',
                variant: BrambleButtonVariant.dark,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 10),
              BrambleButton(
                text: 'Continue with Google',
                variant: BrambleButtonVariant.secondary,
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 32),
              Center(
                child: GestureDetector(
                  onTap: () => context.push('/signup'),
                  child: RichText(
                    text: TextSpan(
                      text: 'New here? ',
                      style: BrambleTypography.bodyMedium(color: BrambleColors.creamSubdued),
                      children: [
                        TextSpan(
                          text: 'Create an account',
                          style: BrambleTypography.bodyMedium(
                            color: BrambleColors.primaryOrangeDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
