import 'package:flutter/material.dart';
import '../theme/bramble_colors.dart';
import '../theme/bramble_typography.dart';
import 'bramble_button.dart';

class BrambleLoading extends StatelessWidget {
  final String? message;

  const BrambleLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(BrambleColors.primaryOrange),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 14),
            Text(
              message!,
              style: BrambleTypography.bodyMedium(
                color: BrambleColors.creamMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class BrambleErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const BrambleErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: BrambleColors.peachSelection,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: BrambleColors.primaryOrange,
                size: 26,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: BrambleTypography.bodyMedium(
                color: BrambleColors.creamInk,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 18),
              BrambleButton(
                text: 'Try Again',
                variant: BrambleButtonVariant.secondary,
                height: 42,
                width: 140,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BrambleEmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const BrambleEmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.auto_stories_outlined,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: BrambleColors.creamSurface,
                border: Border.all(
                  color: BrambleColors.creamBorder.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: BrambleColors.creamMuted,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: BrambleTypography.titleMedium(
                color: BrambleColors.creamInk,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: BrambleTypography.bodyMedium(
                  color: BrambleColors.creamMuted,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              BrambleButton(
                text: actionLabel!,
                variant: BrambleButtonVariant.secondary,
                height: 42,
                width: 160,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
