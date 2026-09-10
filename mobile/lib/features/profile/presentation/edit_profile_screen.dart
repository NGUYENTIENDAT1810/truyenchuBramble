import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../auth/presentation/auth_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() async {
    setState(() => _saving = true);
    await ref.read(authControllerProvider.notifier).updateLocalProfile(
          name: _nameController.text.trim(),
          bio: _bioController.text.trim(),
        );
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    final initial = user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'N';

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: BrambleColors.creamInk.withOpacity(0.1))),
              ),
              child: Row(
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
                  Expanded(
                    child: Text(
                      'Edit profile',
                      textAlign: TextAlign.center,
                      style: BrambleTypography.displaySmall(color: BrambleColors.creamInk)
                          .copyWith(fontSize: 19),
                    ),
                  ),
                  GestureDetector(
                    onTap: _saving ? null : _save,
                    child: Text(
                      'Save',
                      style: BrambleTypography.bodyMedium(
                        color: BrambleColors.primaryOrangeDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: BrambleColors.primaryOrange,
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: BrambleTypography.displayLarge(color: const Color(0xFFF0FAE1))
                                .copyWith(fontSize: 40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text('NAME', style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted)),
                    const SizedBox(height: 7),
                    Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamSurface,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: BrambleTypography.bodyLarge(color: BrambleColors.creamInk),
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('BIO', style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted)),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamSurface,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: TextField(
                        controller: _bioController,
                        maxLines: 4,
                        style: BrambleTypography.bodyMedium(color: BrambleColors.creamInk),
                        decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
