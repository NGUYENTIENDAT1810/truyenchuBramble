import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';

class VerifyScreen extends StatefulWidget {
  final String phone;

  const VerifyScreen({super.key, required this.phone});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  bool get _isComplete => _controllers.every((c) => c.text.isNotEmpty);

  void _onDigitChanged(int index, String value) {
    setState(() {});
    if (value.isNotEmpty && index < 5) {
      _nodes[index + 1].requestFocus();
    }
  }

  void _resend() {
    for (final c in _controllers) {
      c.clear();
    }
    setState(() {});
    _nodes.first.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BrambleColors.creamInk.withOpacity(0.06),
                  ),
                  child: const Icon(Icons.chevron_left_rounded, color: BrambleColors.creamInk, size: 28),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Enter the code',
                style: BrambleTypography.displayLarge(color: BrambleColors.creamInk).copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                'We sent a 6-digit code to ${widget.phone}.',
                style: BrambleTypography.bodyMedium(color: BrambleColors.creamSubdued),
              ),
              const SizedBox(height: 28),
              Row(
                children: List.generate(6, (i) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 5 ? 9 : 0),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: BrambleColors.creamSurface,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: TextField(
                          controller: _controllers[i],
                          focusNode: _nodes[i],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: BrambleTypography.titleMedium(color: BrambleColors.creamInk).copyWith(fontSize: 24),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          onChanged: (v) => _onDigitChanged(i, v),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _resend,
                  child: Text(
                    'Resend code',
                    style: BrambleTypography.bodySmall(
                      color: BrambleColors.primaryOrangeDark,
                      fontWeight: FontWeight.w700,
                    ).copyWith(fontSize: 13.5),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              BrambleButton(
                text: 'Verify & continue',
                onPressed: _isComplete ? () => context.go('/home') : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
