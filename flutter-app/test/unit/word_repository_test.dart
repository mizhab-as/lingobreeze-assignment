import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_breeze/core/error/failures.dart';
import 'package:lingo_breeze/features/vocabulary/data/datasources/word_remote_data_source.dart';
import 'package:lingo_breeze/features/vocabulary/data/models/word_model.dart';
import 'package:lingo_breeze/features/vocabulary/data/repositories/word_repository_impl.dart';

class MockWordRemoteDataSource implements WordRemoteDataSource {
  List<WordModel> wordsResponse = [];
  dynamic getWordsError;

  WordModel? addWordResponse;
  dynamic addWordError;

  dynamic deleteWordError;

  @override
  Future<List<WordModel>> getWords() async {
    if (getWordsError != null) {
      throw getWordsError;
    }
    return wordsResponse;
  }

  @override
  Future<WordModel> addWord(String word, String meaning, String translation) async {
    if (addWordError != null) {
      throw addWordError;
    }
    return addWordResponse!;
  }

  @override
  Future<void> deleteWord(String id) async {
    if (deleteWordError != null) {
      throw deleteWordError;
    }
  }
}

void main() {
  late WordRepositoryImpl repository;
  late MockWordRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockWordRemoteDataSource();
    repository = WordRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('WordRepositoryImpl', () {
    const tWordModel = WordModel(
      id: '1',
      word: 'Apple',
      meaning: 'A fruit',
      translation: 'Manzana',
      createdAt: '2026-06-13T12:00:00Z',
    );

    test('getWords should return list of Words when remote data source call is successful', () async {
      // Arrange
      mockDataSource.wordsResponse = [tWordModel];

      // Act
      final result = await repository.getWords();

      // Assert
      expect(result, equals([tWordModel]));
    });

    test('getWords should throw ConnectionFailure when SocketException occurs', () async {
      // Arrange
      mockDataSource.getWordsError = const SocketException('No Internet');

      // Act & Assert
      expect(
        () => repository.getWords(),
        throwsA(isA<ConnectionFailure>()),
      );
    });

    test('getWords should throw ServerFailure when a general Exception occurs', () async {
      // Arrange
      mockDataSource.getWordsError = Exception('Server Down');

      // Act & Assert
      expect(
        () => repository.getWords(),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('addWord should return saved Word when data source call is successful', () async {
      // Arrange
      mockDataSource.addWordResponse = tWordModel;

      // Act
      final result = await repository.addWord('Apple', 'A fruit', 'Manzana');

      // Assert
      expect(result, equals(tWordModel));
    });

    test('addWord should throw ConnectionFailure when SocketException occurs', () async {
      // Arrange
      mockDataSource.addWordError = const SocketException('No Internet');

      // Act & Assert
      expect(
        () => repository.addWord('Apple', 'A fruit', 'Manzana'),
        throwsA(isA<ConnectionFailure>()),
      );
    });

    test('deleteWord should succeed when remote data source call is successful', () async {
      // Act & Assert
      await repository.deleteWord('1');
    });

    test('deleteWord should throw ConnectionFailure when SocketException occurs', () async {
      // Arrange
      mockDataSource.deleteWordError = const SocketException('No Internet');

      // Act & Assert
      expect(
        () => repository.deleteWord('1'),
        throwsA(isA<ConnectionFailure>()),
      );
    });
  });
}
