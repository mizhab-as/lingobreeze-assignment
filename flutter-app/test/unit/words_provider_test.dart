import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_breeze/core/error/failures.dart';
import 'package:lingo_breeze/core/usecases/usecase.dart';
import 'package:lingo_breeze/features/vocabulary/domain/entities/word.dart';
import 'package:lingo_breeze/features/vocabulary/domain/repositories/word_repository.dart';
import 'package:lingo_breeze/features/vocabulary/domain/usecases/add_word.dart';
import 'package:lingo_breeze/features/vocabulary/domain/usecases/get_words.dart';
import 'package:lingo_breeze/features/vocabulary/domain/usecases/delete_word.dart';
import 'package:lingo_breeze/features/vocabulary/presentation/providers/words_provider.dart';

class DummyWordRepository implements WordRepository {
  @override
  Future<Word> addWord(String word, String meaning, String translation) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Word>> getWords() async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteWord(String id) async {
    throw UnimplementedError();
  }
}

class MockGetWords extends GetWords {
  List<Word> getWordsResponse = [];
  dynamic errorToThrow;

  MockGetWords(super.repository);

  @override
  Future<List<Word>> call(NoParams params) async {
    if (errorToThrow != null) {
      throw errorToThrow;
    }
    return getWordsResponse;
  }
}

class MockAddWord extends AddWord {
  Word? addWordResponse;
  dynamic errorToThrow;

  MockAddWord(super.repository);

  @override
  Future<Word> call(AddWordParams params) async {
    if (errorToThrow != null) {
      throw errorToThrow;
    }
    return addWordResponse!;
  }
}

class MockDeleteWord extends DeleteWord {
  dynamic errorToThrow;

  MockDeleteWord(super.repository);

  @override
  Future<void> call(String id) async {
    if (errorToThrow != null) {
      throw errorToThrow;
    }
  }
}

void main() {
  late WordsProvider provider;
  late MockGetWords mockGetWords;
  late MockAddWord mockAddWord;
  late MockDeleteWord mockDeleteWord;

  setUp(() {
    final repo = DummyWordRepository();
    mockGetWords = MockGetWords(repo);
    mockAddWord = MockAddWord(repo);
    mockDeleteWord = MockDeleteWord(repo);
    provider = WordsProvider(
      getWordsUseCase: mockGetWords,
      addWordUseCase: mockAddWord,
      deleteWordUseCase: mockDeleteWord,
    );
  });

  group('WordsProvider', () {
    const tWord = Word(
      id: '1',
      word: 'Apple',
      meaning: 'A fruit',
      translation: 'Manzana',
      createdAt: '2026-06-13T12:00:00Z',
    );

    test('should start in idle state with empty words', () {
      expect(provider.state, equals(WordsState.idle));
      expect(provider.words, isEmpty);
      expect(provider.errorMessage, isEmpty);
    });

    test('fetchWords should populate words and set state to loaded on success', () async {
      // Arrange
      mockGetWords.getWordsResponse = [tWord];

      // Act
      final future = provider.fetchWords();

      // Verify immediate transition to loading
      expect(provider.state, equals(WordsState.loading));

      await future;

      // Assert
      expect(provider.state, equals(WordsState.loaded));
      expect(provider.words, equals([tWord]));
    });

    test('fetchWords should set error state and messages on Failure', () async {
      // Arrange
      mockGetWords.errorToThrow = const ServerFailure('Database is down');

      // Act
      await provider.fetchWords();

      // Assert
      expect(provider.state, equals(WordsState.error));
      expect(provider.errorMessage, equals('Database is down'));
    });

    test('addWord should insert new word at the top and set state to loaded', () async {
      // Arrange
      mockAddWord.addWordResponse = tWord;

      // Act
      await provider.addWord('Apple', 'A fruit', 'Manzana');

      // Assert
      expect(provider.words.length, 1);
      expect(provider.words.first, equals(tWord));
      expect(provider.state, equals(WordsState.loaded));
    });

    test('deleteWord should remove the word with specified ID from list', () async {
      // Arrange
      mockGetWords.getWordsResponse = [tWord];
      await provider.fetchWords(); // load words first
      expect(provider.words.length, 1);

      // Act
      await provider.deleteWord('1');

      // Assert
      expect(provider.words, isEmpty);
    });
  });
}
