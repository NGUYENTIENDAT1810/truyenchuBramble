import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/bramble_chip.dart';
import 'auth_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;

  final Map<String, bool> _genres = {
    'Slow fantasy': true,
    'Progression': false,
    'Literary': true,
    'Romance': false,
    'Court intrigue': false,
    'Horror': false,
    'Slipstream': false,
    'Epistolary': false,
    'Cultivation': false,
  };

  String _pace = 'daily';

  void _nextStep() async {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      // Save preferences & finish onboarding
      final selectedGenres = _genres.entries.where((e) => e.value).map((e) => e.key).toList();
      await ref.read(authControllerProvider.notifier).updatePreferences({
        'selectedGenres': selectedGenres,
        'readingPace': _pace,
      });
      await LocalStorage.setOnboardingCompleted(true);
      if (mounted) context.go('/home');
    }
  }

  void _skip() async {
    await LocalStorage.setOnboardingCompleted(true);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Read the long way round',
      'What pulls you in?',
      'How fast do you read?',
    ];

    final bodies = [
      'Serials, classics and light novels in one shelf. Chapters arrive when you have time for them, not when a feed decides.',
      'Choose a few. Discovery leans on these, and you can change them any time.',
      'Bramble holds new chapters and paces your goal around your answer.',
    ];

    final ctas = [
      'Pick what you like',
      'Continue',
      'Start reading',
    ];

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress dots
              Row(
                children: List.generate(3, (index) {
                  final isActive = index == _step;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 6),
                    width: isActive ? 30 : 12,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isActive ? BrambleColors.primaryOrange : BrambleColors.creamDivider,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              // Big Logo
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: BrambleColors.primaryOrange,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x382E2B25),
                      blurRadius: 32,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'B',
                    style: BrambleTypography.displayLarge(color: const Color(0xFFFFF2EB)).copyWith(
                      fontSize: 54,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                titles[_step],
                style: BrambleTypography.displayLarge(color: BrambleColors.creamInk).copyWith(
                  fontSize: 34,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                bodies[_step],
                style: BrambleTypography.bodyLarge(color: BrambleColors.creamSubdued),
              ),
              const SizedBox(height: 20),
              // Step 1: Genre selector
              if (_step == 1)
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 9,
                      runSpacing: 10,
                      children: _genres.keys.map((name) {
                        final isSelected = _genres[name] ?? false;
                        return BrambleChip(
                          label: name,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _genres[name] = !isSelected;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              // Step 2: Pace selector
              if (_step == 2)
                Expanded(
                  child: Column(
                    children: [
                      _buildPaceOption(
                        id: 'daily',
                        title: 'A chapter a day',
                        note: 'About 15 minutes each evening',
                      ),
                      const SizedBox(height: 10),
                      _buildPaceOption(
                        id: 'binge',
                        title: 'Weekend binges',
                        note: 'Hold updates and stack them up',
                      ),
                      const SizedBox(height: 10),
                      _buildPaceOption(
                        id: 'slow',
                        title: 'Whenever it happens',
                        note: 'No goals, no streaks, no nudges',
                      ),
                    ],
                  ),
                ),
              if (_step == 0) const Spacer(),
              // CTA buttons
              BrambleButton(
                text: ctas[_step],
                onPressed: _nextStep,
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Skip for now',
                    style: BrambleTypography.bodyMedium(
                      color: BrambleColors.creamMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaceOption({
    required String id,
    required String title,
    required String note,
  }) {
    final isSelected = _pace == id;

    return GestureDetector(
      onTap: () => setState(() => _pace = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? BrambleColors.peachSelection : BrambleColors.creamSurface,
          borderRadius: BorderRadius.circular(22),
          border: isSelected ? Border.all(color: BrambleColors.primaryOrange, width: 2) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: BrambleTypography.displaySmall(color: BrambleColors.creamInk).copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              note,
              style: BrambleTypography.bodySmall(color: BrambleColors.creamSubdued),
            ),
          ],
        ),
      ),
    );
  }
}
