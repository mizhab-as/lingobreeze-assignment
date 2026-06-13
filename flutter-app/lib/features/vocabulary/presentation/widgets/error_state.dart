import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetryPressed;

  const ErrorState({
    super.key,
    required this.errorMessage,
    required this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetryPressed,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.primaryDarkTheme : AppColors.primaryLight,
                foregroundColor: isDark ? AppColors.backgroundDark : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
