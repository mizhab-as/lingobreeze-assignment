import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/words_provider.dart';
import '../widgets/add_word_sheet.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';
import '../widgets/loading_state.dart';
import '../widgets/word_card.dart';
import '../../../../core/theme/app_colors.dart';

class VocabularyScreen extends StatelessWidget {
  const VocabularyScreen({super.key});

  void _showAddWordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.surfaceDark
          : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddWordSheet(),
    ).then((result) {
      if (result == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text('Word saved successfully!'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vocabulary'),
        actions: [
          Consumer<WordsProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: Icon(
                  provider.themeMode == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: () => provider.toggleTheme(context),
                tooltip: 'Toggle Theme',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<WordsProvider>(
        builder: (context, provider, child) {
          if (provider.state == WordsState.loading) {
            return const LoadingState();
          }

          if (provider.state == WordsState.error) {
            return ErrorState(
              errorMessage: provider.errorMessage,
              onRetryPressed: () => provider.fetchWords(),
            );
          }

          if (provider.words.isEmpty) {
            return EmptyState(
              onAddPressed: () => _showAddWordSheet(context),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchWords(),
            color: isDark ? AppColors.primaryDarkTheme : AppColors.primaryLight,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 90),
              itemCount: provider.words.length + 1,
              itemBuilder: (context, index) {
                // Return a header showing stats as the first item
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SAVED WORDS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${provider.words.length} items',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                final word = provider.words[index - 1];
                return WordCard(word: word);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWordSheet(context),
        tooltip: 'Add Word',
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
