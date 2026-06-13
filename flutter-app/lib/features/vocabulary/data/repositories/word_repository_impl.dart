import 'dart:io';
import '../../../../core/error/failures.dart';
import '../../domain/entities/word.dart';
import '../../domain/repositories/word_repository.dart';
import '../datasources/word_remote_data_source.dart';

class WordRepositoryImpl implements WordRepository {
  final WordRemoteDataSource remoteDataSource;

  WordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Word>> getWords() async {
    try {
      final remoteWords = await remoteDataSource.getWords();
      return remoteWords;
    } on SocketException catch (_) {
      throw const ConnectionFailure('No internet connection. Please check your network.');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Word> addWord(String word, String meaning, String translation) async {
    try {
      final remoteWord = await remoteDataSource.addWord(word, meaning, translation);
      return remoteWord;
    } on SocketException catch (_) {
      throw const ConnectionFailure('No internet connection. Please check your network.');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteWord(String id) async {
    try {
      await remoteDataSource.deleteWord(id);
    } on SocketException catch (_) {
      throw const ConnectionFailure('No internet connection. Please check your network.');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
