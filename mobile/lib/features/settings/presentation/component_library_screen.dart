import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../../core/widgets/bramble_chip.dart';

class ComponentLibraryScreen extends StatefulWidget {
  const ComponentLibraryScreen({super.key});

  @override
  State<ComponentLibraryScreen> createState() => _ComponentLibraryScreenState();
}

class _ComponentLibraryScreenState extends State<ComponentLibraryScreen> {
  String _selectedChip = 'active';
  bool _toggleA = true;
  bool _toggleB = false;
  int _segment = 0;

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
                  Text(
                    'Components',
                    style: BrambleTypography.displaySmall(color: BrambleColors.creamInk).copyWith(fontSize: 19),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel('Buttons'),
                    Column(
                      children: [
                        BrambleButton(text: 'Primary', onPressed: () {}),
                        const SizedBox(height: 10),
                        BrambleButton(text: 'Secondary', variant: BrambleButtonVariant.secondary, onPressed: () {}),
                        const SizedBox(height: 10),
                        BrambleButton(text: 'Dark', variant: BrambleButtonVariant.dark, onPressed: () {}),
                        const SizedBox(height: 10),
                        BrambleButton(text: 'Peach', variant: BrambleButtonVariant.peach, onPressed: () {}),
                        const SizedBox(height: 10),
                        BrambleButton(text: 'Outline', variant: BrambleButtonVariant.outline, onPressed: () {}),
                      ],
                    ),
                    const SizedBox(height: 26),
                    _sectionLabel('Tags & chips'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _tag('Accent tag', BrambleColors.peachSelection, BrambleColors.peachDark),
                        _tag('Accent 2 tag', BrambleColors.lightSage, BrambleColors.deepGreen),
                        BrambleChip(
                          label: 'Chip · active',
                          isSelected: _selectedChip == 'active',
                          onTap: () => setState(() => _selectedChip = 'active'),
                        ),
                        BrambleChip(
                          label: 'Chip · idle',
                          isSelected: _selectedChip == 'idle2',
                          onTap: () => setState(() => _selectedChip = 'idle2'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    _sectionLabel('Toggle'),
                    Row(
                      children: [
                        _switchDemo(_toggleA, (v) => setState(() => _toggleA = v)),
                        const SizedBox(width: 14),
                        _switchDemo(_toggleB, (v) => setState(() => _toggleB = v)),
                      ],
                    ),
                    const SizedBox(height: 26),
                    _sectionLabel('Segmented control'),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamSurface,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: List.generate(3, (i) {
                          final isSelected = _segment == i;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _segment = i),
                              child: Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  color: isSelected ? BrambleColors.creamBg : Colors.transparent,
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: isSelected
                                      ? const [BoxShadow(color: Color(0x1F2E2B25), blurRadius: 2, offset: Offset(0, 1))]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    i == 0 ? 'Selected' : 'Option',
                                    style: BrambleTypography.bodySmall(
                                      color: isSelected ? BrambleColors.creamInk : BrambleColors.creamMuted,
                                      fontWeight: FontWeight.w700,
                                    ).copyWith(fontSize: 13.5),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 26),
                    _sectionLabel('Input field'),
                    Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamSurface,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: TextField(
                        style: BrambleTypography.bodyLarge(color: BrambleColors.creamInk),
                        decoration: InputDecoration(
                          hintText: 'Placeholder text',
                          hintStyle: BrambleTypography.bodyLarge(color: BrambleColors.creamMuted),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    _sectionLabel('Card'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: BrambleColors.creamSurface,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card title',
                            style: BrambleTypography.bodyLarge(
                              color: BrambleColors.creamInk,
                              fontWeight: FontWeight.w700,
                            ).copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Body copy inside a surface-filled card, the base content container.',
                            style: BrambleTypography.bodySmall(color: BrambleColors.creamSubdued)
                                .copyWith(fontSize: 13, height: 1.5),
                          ),
                        ],
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

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Text(text, style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted)),
    );
  }

  Widget _tag(String label, Color bg, Color fg) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Center(
        child: Text(
          label,
          style: BrambleTypography.bodySmall(color: fg, fontWeight: FontWeight.w700).copyWith(fontSize: 11.5),
        ),
      ),
    );
  }

  Widget _switchDemo(bool value, ValueChanged<bool> onChanged) {
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
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF9F4ED)),
          ),
        ),
      ),
    );
  }
}
