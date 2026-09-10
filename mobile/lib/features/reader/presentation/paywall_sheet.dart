import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../auth/presentation/auth_controller.dart';
import 'reader_controller.dart';

class PaywallSheet extends ConsumerStatefulWidget {
  final String chapterId;
  final int chapterNumber;
  final String chapterTitle;
  final int coinPrice;
  final VoidCallback onUnlocked;

  const PaywallSheet({
    super.key,
    required this.chapterId,
    required this.chapterNumber,
    required this.chapterTitle,
    this.coinPrice = 30,
    required this.onUnlocked,
  });

  @override
  ConsumerState<PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends ConsumerState<PaywallSheet> {
  bool _isUnlocking = false;

  void _handleUnlock() async {
    setState(() => _isUnlocking = true);
    try {
      final repo = ref.read(readerRepositoryProvider);
      final res = await repo.unlockChapter(widget.chapterId);
      final remainingCoins = res['remainingCoins'] as int?;

      if (remainingCoins != null) {
        final currentUser = ref.read(authControllerProvider).user;
        if (currentUser != null) {
          ref.read(authControllerProvider.notifier).checkInitialAuth();
        }
      }

      widget.onUnlocked();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chapter unlocked successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isUnlocking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    final coins = user?.coins ?? 120;

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 38),
      decoration: const BoxDecoration(
        color: BrambleColors.creamBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x382E2B25),
            blurRadius: 32,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: BrambleColors.creamDivider,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chapter ${widget.chapterNumber}',
                  style: BrambleTypography.displaySmall(
                    color: BrambleColors.creamInk,
                  ).copyWith(fontSize: 25),
                ),
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    color: BrambleColors.peachSelection,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: BrambleColors.primaryOrange,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '$coins coins',
                        style: BrambleTypography.bodySmall(
                          color: BrambleColors.peachDark,
                          fontWeight: FontWeight.w800,
                        ).copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '“${widget.chapterTitle}” · Free for everyone in 6 hours.',
              style: BrambleTypography.bodyMedium(color: BrambleColors.creamSubdued),
            ),
            const SizedBox(height: 18),

            // Unlock button
            BrambleButton(
              text: 'Unlock for ${widget.coinPrice} coins',
              isLoading: _isUnlocking,
              onPressed: _handleUnlock,
            ),
            const SizedBox(height: 14),

            // Bramble+ banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: BrambleColors.deepGreen,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bramble+',
                    style: BrambleTypography.displaySmall(
                      color: const Color(0xFFF0FAE1),
                    ).copyWith(fontSize: 21),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Every chapter the moment it posts, offline downloads, no ads. 40% goes to the authors you read.',
                    style: BrambleTypography.bodySmall(
                      color: const Color(0xFFF0FAE1).withOpacity(0.85),
                    ).copyWith(fontSize: 13.5, height: 1.55),
                  ),
                  const SizedBox(height: 14),
                  BrambleButton(
                    text: 'Try 7 days free',
                    variant: BrambleButtonVariant.secondary,
                    height: 48,
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bramble+ free trial activated!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Coin packs
            Row(
              children: [
                _buildCoinPack(coins: '100', price: '\$1.99'),
                const SizedBox(width: 9),
                _buildCoinPack(coins: '550', price: '\$8.99'),
                const SizedBox(width: 9),
                _buildCoinPack(coins: '1200', price: '\$17.99'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinPack({required String coins, required String price}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          context.push('/payment', extra: {'coins': coins, 'price': price});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
          decoration: BoxDecoration(
            color: BrambleColors.creamSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                coins,
                style: BrambleTypography.displaySmall(
                  color: BrambleColors.creamInk,
                ).copyWith(fontSize: 19),
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: BrambleTypography.bodySmall(
                  color: BrambleColors.creamSubdued,
                  fontWeight: FontWeight.w600,
                ).copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
