import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/word.dart';
import '../providers/words_provider.dart';
import '../../../../core/theme/app_colors.dart';

class WordCard extends StatelessWidget {
  final Word word;

  const WordCard({super.key, required this.word});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          title: const Text('Delete Word'),
          content: Text('Are you sure you want to delete "${word.word}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  final provider = Provider.of<WordsProvider>(context, listen: false);
                  await provider.deleteWord(word.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Word deleted successfully'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete word: $e'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: AppColors.error)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Parse date if present
    final dateStr = word.createdAt != null
        ? (DateTime.tryParse(word.createdAt!)?.toLocal().toString().split(' ').first)
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isDark ? AppColors.accentDarkTheme : AppColors.primaryLight,
                width: 5,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      word.word,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (dateStr != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.primaryDarkTheme.withOpacity(0.1)
                                : AppColors.primaryLight.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            dateStr,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.primaryDarkTheme : AppColors.primaryLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: isDark ? Colors.redAccent[100] : AppColors.error,
                          size: 20,
                        ),
                        onPressed: () => _confirmDelete(context),
                        tooltip: 'Delete Word',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                height: 1,
              ),
              const SizedBox(height: 12),
              
              // Meaning row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meaning: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      word.meaning,
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Translation row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Translation: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.accentDarkTheme : AppColors.accentLight,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      word.translation,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
