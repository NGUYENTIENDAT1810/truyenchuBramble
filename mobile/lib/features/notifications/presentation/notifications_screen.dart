import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import 'cubit/notifications_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Set<int> _readOverrides = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().markAllRead();
    });
  }

  List<NotificationItem> get _items => const [
        NotificationItem(
          icon: '📖',
          bg: BrambleColors.lightSage,
          fg: BrambleColors.deepGreen,
          text: 'The Salt Almanac just posted Chapter 48 — "The Harbour Ledger."',
          time: '12m ago',
          route: '/library',
        ),
        NotificationItem(
          icon: '💬',
          bg: BrambleColors.peachSelection,
          fg: BrambleColors.primaryOrangeDark,
          text: 'oleander replied to your note on chapter 47.',
          time: '1h ago',
          route: '/library',
        ),
        NotificationItem(
          icon: '✍️',
          bg: Color(0xFFCFE3FF),
          fg: Color(0xFF1A4FA0),
          text: 'Wen Ito posted an update: chapter 48 runs a day late.',
          time: '3h ago',
          route: '/library',
        ),
        NotificationItem(
          icon: '🔥',
          bg: BrambleColors.peachSelection,
          fg: BrambleColors.primaryOrangeDark,
          text: 'You kept a 12-day streak. One more chapter today to extend it.',
          time: '5h ago',
          route: '/stats',
        ),
        NotificationItem(
          icon: '📚',
          bg: BrambleColors.lightSage,
          fg: BrambleColors.deepGreen,
          text: 'Nine Lanterns, from your library, posted a new chapter.',
          time: '1d ago',
          route: '/library',
        ),
      ];

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
                color: BrambleColors.creamBg,
                border: Border(
                  bottom: BorderSide(color: BrambleColors.creamInk.withOpacity(0.1)),
                ),
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
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: BrambleColors.creamInk,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Notifications',
                      style: BrambleTypography.displaySmall(color: BrambleColors.creamInk)
                          .copyWith(fontSize: 19),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _readOverrides.addAll(List.generate(_items.length, (i) => i));
                    }),
                    child: Text(
                      'Mark all read',
                      style: BrambleTypography.bodySmall(
                        color: BrambleColors.primaryOrangeDark,
                        fontWeight: FontWeight.w700,
                      ).copyWith(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final n = _items[index];
                  final unread = index < 3 && !_readOverrides.contains(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() => _readOverrides.add(index));
                      context.go(n.route);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: BrambleColors.creamInk.withOpacity(0.08)),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: n.bg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(child: Text(n.icon, style: const TextStyle(fontSize: 17))),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  n.text,
                                  style: BrambleTypography.bodyMedium(
                                    color: BrambleColors.creamInk,
                                    fontWeight: FontWeight.w600,
                                  ).copyWith(fontSize: 14.5, height: 1.4),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  n.time,
                                  style: BrambleTypography.bodySmall(color: BrambleColors.creamMuted)
                                      .copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          if (unread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: BrambleColors.primaryOrange,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
