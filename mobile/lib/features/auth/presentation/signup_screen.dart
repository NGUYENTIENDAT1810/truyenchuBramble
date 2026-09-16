import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/bramble_text_field.dart';
import 'bloc/auth_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _agreed = true;
  bool _isPhoneMode = false;

  @override
  void dispose() {
    _nameController.dispose();
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

  void _handleSignup() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the reading terms')),
      );
      return;
    }

    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            email: email,
            password: password,
            name: name,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/onboarding');
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
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular back button
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: BrambleColors.creamInk.withOpacity(0.06),
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: BrambleColors.creamInk,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Start your shelf',
                    style: BrambleTypography.displayLarge(color: BrambleColors.creamInk),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Free. Three chapters a day, notes, and offline reading on one device.',
                    style: BrambleTypography.bodyMedium(color: BrambleColors.creamSubdued),
                  ),
                  const SizedBox(height: 26),
                  BrambleTextField(
                    label: 'READING NAME',
                    placeholder: 'How notes will sign you',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 14),
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
                  const SizedBox(height: 14),
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
                      placeholder: '8 characters or more',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Checkbox row
                    GestureDetector(
                      onTap: () => setState(() => _agreed = !_agreed),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: _agreed ? BrambleColors.primaryOrange : BrambleColors.creamSurface,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: _agreed
                                ? const Center(
                                    child: Icon(
                                      Icons.check_rounded,
                                      size: 18,
                                      color: Color(0xFFFFF2EB),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "I'm happy with the reading terms and the note guidelines.",
                              style: BrambleTypography.bodySmall(
                                color: BrambleColors.creamSubdued,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    BrambleButton(
                      text: 'Create account',
                      isLoading: isLoading,
                      onPressed: _handleSignup,
                    ),
                  ] else ...[
                    BrambleTextField(
                      label: 'PHONE NUMBER',
                      placeholder: '+84 90 123 4567',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 28),
                    BrambleButton(
                      text: 'Send code',
                      onPressed: _sendCode,
                    ),
                  ],
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already reading with us? ',
                          style: BrambleTypography.bodyMedium(color: BrambleColors.creamSubdued),
                          children: [
                            TextSpan(
                              text: 'Log in',
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
