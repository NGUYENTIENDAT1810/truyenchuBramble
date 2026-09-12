import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/bramble_text_field.dart';
import 'bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'noor@example.com');
  final _passwordController = TextEditingController(text: 'password123');
  final _phoneController = TextEditingController();
  bool _isPhoneMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _sendCode() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;
    context.push('/verify', extra: phone);
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    context.read<AuthBloc>().add(
          AuthLoginRequested(email: email, password: password),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/home');
        } else if (state is Unauthenticated && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;

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
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: BrambleColors.creamSurface,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _authModeTab('Email', !_isPhoneMode, () => setState(() => _isPhoneMode = false))),
                        Expanded(child: _authModeTab('Phone', _isPhoneMode, () => setState(() => _isPhoneMode = true))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (!_isPhoneMode) ...[
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
                  ] else ...[
                    BrambleTextField(
                      label: 'PHONE NUMBER',
                      placeholder: '+84 90 123 4567',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 22),
                    BrambleButton(
                      text: 'Send code',
                      onPressed: _sendCode,
                    ),
                  ],
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
      },
    );
  }

  Widget _authModeTab(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 38,
        decoration: BoxDecoration(
          color: isActive ? BrambleColors.creamBg : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isActive
              ? const [BoxShadow(color: Color(0x1F2E2B25), blurRadius: 2, offset: Offset(0, 1))]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: BrambleTypography.bodySmall(
              color: isActive ? BrambleColors.creamInk : BrambleColors.creamMuted,
              fontWeight: FontWeight.w700,
            ).copyWith(fontSize: 13.5),
          ),
        ),
      ),
    );
  }
}
