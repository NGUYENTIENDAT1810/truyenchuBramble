import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../reader/presentation/reader_controller.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _wifi = true;
  bool _keepScreen = false;
  bool _hideSpoilers = true;
  bool _newChapter = true;
  bool _authorPosts = true;
  bool _digest = false;

  void _handleLogout() async {
    await ref.read(authControllerProvider.notifier).logout();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    final readerSettings = ref.watch(readerSettingsProvider);

    final themeName = readerSettings.themeMode.name;
    final faceName = readerSettings.fontFamily == 'serif' ? 'Lora' : 'Figtree';
    final fontDesc = '${themeName[0].toUpperCase()}${themeName.substring(1)} · $faceName · ${readerSettings.fontSize.toInt()}px';

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
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
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: BrambleColors.creamInk,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Settings',
                    style: BrambleTypography.displayLarge(
                      color: BrambleColors.creamInk,
                    ).copyWith(fontSize: 31),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // User Account Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: BrambleColors.creamSurface,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: BrambleColors.sageGreen,
                      ),
                      child: Center(
                        child: Text(
                          user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'N',
                          style: BrambleTypography.displaySmall(
                            color: const Color(0xFFF0FAE1),
                          ).copyWith(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Noor Rahim',
                            style: BrambleTypography.bodyLarge(
                              color: BrambleColors.creamInk,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? 'noor@example.com',
                            style: BrambleTypography.bodySmall(
                              color: BrambleColors.creamMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: BrambleColors.deepGreen,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Center(
                        child: Text(
                          'TRIAL',
                          style: BrambleTypography.bodySmall(
                            color: const Color(0xFFF0FAE1),
                            fontWeight: FontWeight.w800,
                          ).copyWith(fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section: READING
              _buildSectionHeader('READING'),
              _buildSettingRow(
                label: 'Font & theme',
                note: fontDesc,
                isLink: true,
                linkValue: 'Open',
                onTap: () => context.push('/appearance'),
              ),
              _buildSettingRow(
                label: 'Download over Wi-Fi only',
                note: 'Chapters queue until you are on Wi-Fi',
                isToggle: true,
                toggleValue: _wifi,
                onToggle: (v) => setState(() => _wifi = v),
              ),
              _buildSettingRow(
                label: 'Keep screen on while reading',
                isToggle: true,
                toggleValue: _keepScreen,
                onToggle: (v) => setState(() => _keepScreen = v),
              ),
              _buildSettingRow(
                label: 'Hide spoiler notes',
                note: 'Blur notes from chapters past yours',
                isToggle: true,
                toggleValue: _hideSpoilers,
                onToggle: (v) => setState(() => _hideSpoilers = v),
              ),
              const SizedBox(height: 24),

              // Section: NOTIFICATIONS
              _buildSectionHeader('NOTIFICATIONS'),
              _buildSettingRow(
                label: 'New chapter',
                note: 'From novels in your library',
                isToggle: true,
                toggleValue: _newChapter,
                onToggle: (v) => setState(() => _newChapter = v),
              ),
              _buildSettingRow(
                label: 'Author posts',
                isToggle: true,
                toggleValue: _authorPosts,
                onToggle: (v) => setState(() => _authorPosts = v),
              ),
              _buildSettingRow(
                label: 'Weekly digest',
                note: 'Sunday, what you read and missed',
                isToggle: true,
                toggleValue: _digest,
                onToggle: (v) => setState(() => _digest = v),
              ),
              const SizedBox(height: 24),

              // Section: ACCOUNT
              _buildSectionHeader('ACCOUNT'),
              _buildSettingRow(
                label: 'Coins & Bramble+',
                note: '${user?.coins ?? 120} coins · trial active',
                isLink: true,
                linkValue: 'Manage',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coins balance: 120 coins')),
                  );
                },
              ),
              _buildSettingRow(
                label: 'Language',
                isLink: true,
                linkValue: 'English',
                onTap: () {},
              ),
              _buildSettingRow(
                label: 'Reading data',
                note: 'Export or delete your history',
                isLink: true,
                linkValue: 'Open',
                onTap: () => context.go('/stats'),
              ),
              const SizedBox(height: 28),

              // Logout Button
              BrambleButton(
                text: 'Log out',
                variant: BrambleButtonVariant.peach,
                onPressed: _handleLogout,
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Bramble ${AppConstants.appVersion}',
                  style: BrambleTypography.bodySmall(
                    color: const Color(0xFFA19786),
                  ).copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted),
      ),
    );
  }

  Widget _buildSettingRow({
    required String label,
    String? note,
    bool isToggle = false,
    bool toggleValue = false,
    ValueChanged<bool>? onToggle,
    bool isLink = false,
    String? linkValue,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BrambleColors.creamInk.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: BrambleTypography.bodyMedium(
                    color: BrambleColors.creamInk,
                    fontWeight: FontWeight.w600,
                  ).copyWith(fontSize: 15),
                ),
                if (note != null && note.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    note,
                    style: BrambleTypography.bodySmall(
                      color: BrambleColors.creamMuted,
                    ).copyWith(fontSize: 12.5),
                  ),
                ],
              ],
            ),
          ),
          if (isToggle)
            _buildCustomSwitch(
              value: toggleValue,
              onChanged: onToggle ?? (_) {},
            ),
          if (isLink)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Text(
                    linkValue ?? '',
                    style: BrambleTypography.bodySmall(
                      color: BrambleColors.primaryOrangeDark,
                      fontWeight: FontWeight.w700,
                    ).copyWith(fontSize: 13.5),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: BrambleColors.primaryOrangeDark,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCustomSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 52,
        height: 31,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: value ? BrambleColors.primaryOrange : BrambleColors.creamDivider,
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF9F4ED),
              boxShadow: [
                BoxShadow(
                  color: Color(0x242E2B25),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
