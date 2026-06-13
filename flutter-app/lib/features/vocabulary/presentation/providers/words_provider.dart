import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/word.dart';
import '../../domain/usecases/add_word.dart';
import '../../domain/usecases/get_words.dart';
import '../../domain/usecases/delete_word.dart';

enum WordsState { idle, loading, loaded, error }

class WordsProvider extends ChangeNotifier {
  final GetWords getWordsUseCase;
  final AddWord addWordUseCase;
  final DeleteWord deleteWordUseCase;

  List<Word> _words = [];
  WordsState _state = WordsState.idle;
  String _errorMessage = '';
  ThemeMode _themeMode = ThemeMode.system;

  List<Word> get words => _words;
  WordsState get state => _state;
  String get errorMessage => _errorMessage;
  ThemeMode get themeMode => _themeMode;

  WordsProvider({
    required this.getWordsUseCase,
    required this.addWordUseCase,
    required this.deleteWordUseCase,
  });

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      final brightness = MediaQuery.platformBrightnessOf(context);
      _themeMode = brightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    } else {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> fetchWords() async {
    _state = WordsState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _words = await getWordsUseCase(const NoParams());
      _state = WordsState.loaded;
    } on Failure catch (failure) {
      _state = WordsState.error;
      _errorMessage = failure.message;
    } catch (e) {
      _state = WordsState.error;
      _errorMessage = 'An unexpected error occurred: $e';
    }
    notifyListeners();
  }

  Future<void> addWord(String word, String meaning, String translation) async {
    try {
      final newWord = await addWordUseCase(
        AddWordParams(word: word, meaning: meaning, translation: translation),
      );
      _words.insert(0, newWord);
      _state = WordsState.loaded;
      notifyListeners();
    } on Failure catch (failure) {
      throw Exception(failure.message);
    } catch (e) {
      throw Exception('Failed to add word: $e');
    }
  }

  Future<void> deleteWord(String id) async {
    try {
      await deleteWordUseCase(id);
      _words.removeWhere((w) => w.id == id);
      notifyListeners();
    } on Failure catch (failure) {
      throw Exception(failure.message);
    } catch (e) {
      throw Exception('Failed to delete word: $e');
    }
  }
}
