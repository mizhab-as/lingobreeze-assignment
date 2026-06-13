import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const EmptyState({super.key, required this.onAddPressed});

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
            // Decorative floating book/bookmark icon background
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryDarkTheme.withOpacity(0.1)
                    : AppColors.primaryLight.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                size: 56,
                color: isDark ? AppColors.primaryDarkTheme : AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "You haven't saved any words yet.",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Build your personal vocabulary by adding words, translations, and their meanings to learn them later.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Your First Word'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
