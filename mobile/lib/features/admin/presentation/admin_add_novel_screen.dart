import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/bramble_chip.dart';
import '../../books/presentation/novel_detail_screen.dart' show bookRepositoryProvider;

class AdminAddNovelScreen extends ConsumerStatefulWidget {
  const AdminAddNovelScreen({super.key});

  @override
  ConsumerState<AdminAddNovelScreen> createState() => _AdminAddNovelScreenState();
}

class _AdminAddNovelScreenState extends ConsumerState<AdminAddNovelScreen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _blurbController = TextEditingController();
  String _cover = 'salt';
  String _tag = 'Slow fantasy';
  bool _published = false;
  bool _publishing = false;

  static const _covers = {
    'salt': Color(0xFF56633F),
    'lantern': Color(0xFFB2622D),
    'house': Color(0xFFCCDBB2),
    'copper': Color(0xFFFFC6A5),
    'machinist': Color(0xFF474238),
    'tide': Color(0xFF8FA073),
  };

  static const _tags = ['Slow fantasy', 'Progression', 'Literary', 'Court intrigue', 'Slipstream', 'Epistolary'];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _blurbController.dispose();
    super.dispose();
  }

  bool get _ready =>
      _titleController.text.trim().isNotEmpty &&
      _authorController.text.trim().isNotEmpty &&
      _blurbController.text.trim().isNotEmpty;

  void _publish() async {
    if (!_ready || _published || _publishing) return;
    setState(() => _publishing = true);
    try {
      await ref.read(bookRepositoryProvider).createBook(
            title: _titleController.text.trim(),
            description: _blurbController.text.trim(),
          );
      if (mounted) setState(() => _published = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add a novel',
                          style: BrambleTypography.displaySmall(color: BrambleColors.creamInk)
                              .copyWith(fontSize: 19),
                        ),
                        Text(
                          'Admin only',
                          style: BrambleTypography.bodySmall(color: BrambleColors.creamMuted)
                              .copyWith(fontSize: 12),
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
                        'ADMIN',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _field('TITLE', _titleController, 'Novel title'),
                    const SizedBox(height: 14),
                    _field('AUTHOR', _authorController, 'Author name'),
                    const SizedBox(height: 14),
                    Text('COVER COLOUR', style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted)),
                    const SizedBox(height: 9),
                    Row(
                      children: _covers.entries.map((e) {
                        final isSelected = _cover == e.key;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => setState(() => _cover = e.key),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: e.value,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: BrambleColors.primaryOrange, width: 3)
                                    : Border.all(color: BrambleColors.creamInk.withOpacity(0.12)),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text('BLURB', style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted)),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamSurface,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: TextField(
                        controller: _blurbController,
                        maxLines: 4,
                        onChanged: (_) => setState(() {}),
                        style: BrambleTypography.bodyMedium(color: BrambleColors.creamInk),
                        decoration: InputDecoration(
                          hintText: 'What is this novel about?',
                          hintStyle: BrambleTypography.bodyMedium(color: BrambleColors.creamMuted),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('GENRE TAG', style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted)),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tags
                          .map((t) => BrambleChip(
                                label: t,
                                isSelected: _tag == t,
                                onTap: () => setState(() => _tag = t),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFC0B6A5), width: 2, style: BorderStyle.solid),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.file_upload_outlined, size: 19, color: BrambleColors.creamMuted),
                          const SizedBox(width: 8),
                          Text(
                            'Upload chapter 1 (.txt / .docx)',
                            style: BrambleTypography.bodySmall(
                              color: BrambleColors.creamMuted,
                              fontWeight: FontWeight.w700,
                            ).copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    BrambleButton(
                      text: _published ? 'Published' : 'Publish novel',
                      variant: _published ? BrambleButtonVariant.dark : BrambleButtonVariant.primary,
                      isLoading: _publishing,
                      onPressed: _published ? null : (_ready ? _publish : null),
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

  Widget _field(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted)),
        const SizedBox(height: 7),
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: BrambleColors.creamSurface,
            borderRadius: BorderRadius.circular(999),
          ),
          child: TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            style: BrambleTypography.bodyLarge(color: BrambleColors.creamInk),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: BrambleTypography.bodyLarge(color: BrambleColors.creamMuted),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
