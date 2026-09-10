import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationItem {
  final String icon;
  final Color bg;
  final Color fg;
  final String text;
  final String time;
  final String route;

  const NotificationItem({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.text,
    required this.time,
    required this.route,
  });
}

final notificationsUnreadProvider = StateProvider<bool>((ref) => true);
