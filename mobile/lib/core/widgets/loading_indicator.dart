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
              strokeWidth: 3,
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
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: BrambleColors.peachSelection,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: BrambleColors.primaryOrange,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
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
                height: 44,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
