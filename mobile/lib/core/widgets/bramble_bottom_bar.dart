import 'package:flutter/material.dart';
import '../theme/bramble_colors.dart';
import '../theme/bramble_typography.dart';

class BrambleBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BrambleBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (label: 'Home', icon: Icons.home_rounded),
      (label: 'Library', icon: Icons.auto_stories_rounded),
      (label: 'Discover', icon: Icons.search_rounded),
      (label: 'Stats', icon: Icons.insights_rounded),
    ];

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding > 0 ? bottomPadding + 4 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            BrambleColors.creamBg.withOpacity(0.0),
            BrambleColors.creamBg.withOpacity(0.88),
            BrambleColors.creamBg,
          ],
          stops: const [0.0, 0.45, 0.85],
        ),
      ),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          color: BrambleColors.creamSurface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: BrambleColors.creamBorder.withOpacity(0.6),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F2E2B25),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isActive = currentIndex == index;

            return Expanded(
              flex: isActive ? 3 : 2,
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: isActive ? BrambleColors.primaryOrange : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: isActive
                        ? const [
                            BoxShadow(
                              color: Color(0x28C67139),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 20,
                        color: isActive ? const Color(0xFFFFF2EB) : BrambleColors.creamSubdued,
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: BrambleTypography.bodySmall(
                              color: const Color(0xFFFFF2EB),
                              fontWeight: FontWeight.w800,
                            ).copyWith(fontSize: 13),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
