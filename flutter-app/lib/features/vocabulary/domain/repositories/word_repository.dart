import '../entities/word.dart';

abstract class WordRepository {
  Future<List<Word>> getWords();
  Future<Word> addWord(String word, String meaning, String translation);
  Future<void> deleteWord(String id);
}
