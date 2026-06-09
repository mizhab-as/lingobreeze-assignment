import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/api_service.dart';

enum WordsState { idle, loading, loaded, error }

class WordsProvider extends ChangeNotifier {
  final ApiService api;
  List<Word> words = [];
  WordsState state = WordsState.idle;
  String errorMessage = '';

  WordsProvider({ApiService? apiService}) : api = apiService ?? ApiService();

  Future<void> fetchWords() async {
    state = WordsState.loading;
    errorMessage = '';
    notifyListeners();
    try {
      words = await api.fetchWords();
      state = WordsState.loaded;
    } catch (e) {
      state = WordsState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> addWord(String word, String meaning, String translation) async {
    try {
      final w = await api.addWord(word, meaning, translation);
      words.insert(0, w);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
