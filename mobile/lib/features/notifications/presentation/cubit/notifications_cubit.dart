import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class NotificationsCubit extends Cubit<bool> {
  NotificationsCubit() : super(true);

  void markAllRead() => emit(false);
  void setHasUnread(bool value) => emit(value);
}
