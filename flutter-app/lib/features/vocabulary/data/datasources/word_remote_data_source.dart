import '../models/word_model.dart';

abstract class WordRemoteDataSource {
  Future<List<WordModel>> getWords();
  Future<WordModel> addWord(String word, String meaning, String translation);
  Future<void> deleteWord(String id);
}
