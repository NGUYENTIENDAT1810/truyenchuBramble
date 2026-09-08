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
      (label: 'You', icon: Icons.person_rounded),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            BrambleColors.creamBg.withOpacity(0.0),
            BrambleColors.creamBg.withOpacity(0.85),
            BrambleColors.creamBg,
          ],
          stops: const [0.0, 0.4, 0.7],
        ),
      ),
      child: Container(
        height: 60,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: BrambleColors.creamSurface,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x382E2B25),
              blurRadius: 32,
              offset: Offset(0, 12),
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
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isActive ? BrambleColors.primaryOrange : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: isActive
                        ? const [
                            BoxShadow(
                              color: Color(0x282E2B25),
                              blurRadius: 10,
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
                            ).copyWith(fontSize: 13.5),
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
