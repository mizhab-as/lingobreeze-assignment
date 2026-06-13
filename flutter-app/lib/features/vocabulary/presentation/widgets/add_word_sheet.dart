import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/words_provider.dart';
import '../../../../core/theme/app_colors.dart';

class AddWordSheet extends StatefulWidget {
  const AddWordSheet({super.key});

  @override
  State<AddWordSheet> createState() => _AddWordSheetState();
}

class _AddWordSheetState extends State<AddWordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _wordCtrl = TextEditingController();
  final _meaningCtrl = TextEditingController();
  final _translationCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _wordCtrl.dispose();
    _meaningCtrl.dispose();
    _translationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final provider = Provider.of<WordsProvider>(context, listen: false);

    try {
      await provider.addWord(
        _wordCtrl.text.trim(),
        _meaningCtrl.text.trim(),
        _translationCtrl.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop(true); // Return true indicating success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      // Ensure the sheet rises above the software keyboard
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Add New Word',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _wordCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Word',
                    hintText: 'e.g. Apple',
                    prefixIcon: Icon(Icons.abc_rounded),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a word';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _meaningCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Meaning',
                    hintText: 'e.g. A fruit',
                    prefixIcon: Icon(Icons.description_rounded),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the meaning';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _translationCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Translation',
                    hintText: 'e.g. Manzana',
                    prefixIcon: Icon(Icons.translate_rounded),
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submitForm(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the translation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                _isSaving
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Save Word'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
