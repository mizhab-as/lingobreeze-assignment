import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:lingo_breeze/features/vocabulary/domain/entities/word.dart';
import 'package:lingo_breeze/features/vocabulary/domain/repositories/word_repository.dart';
import 'package:lingo_breeze/features/vocabulary/domain/usecases/add_word.dart';
import 'package:lingo_breeze/features/vocabulary/domain/usecases/get_words.dart';
import 'package:lingo_breeze/features/vocabulary/domain/usecases/delete_word.dart';
import 'package:lingo_breeze/features/vocabulary/presentation/pages/vocabulary_screen.dart';
import 'package:lingo_breeze/features/vocabulary/presentation/providers/words_provider.dart';

class FakeWordRepository implements WordRepository {
  @override
  Future<Word> addWord(String word, String meaning, String translation) async {
    return Word(id: '1', word: word, meaning: meaning, translation: translation);
  }

  @override
  Future<List<Word>> getWords() async {
    return [
      const Word(id: '1', word: 'Apple', meaning: 'A fruit', translation: 'Manzana'),
    ];
  }

  @override
  Future<void> deleteWord(String id) async {}
}

class FakeEmptyWordRepository implements WordRepository {
  @override
  Future<Word> addWord(String word, String meaning, String translation) async {
    return Word(id: '1', word: word, meaning: meaning, translation: translation);
  }

  @override
  Future<List<Word>> getWords() async {
    return [];
  }

  @override
  Future<void> deleteWord(String id) async {}
}

void main() {
  group('VocabularyScreen Widget Tests', () {
    testWidgets('displays empty state when no words exist', (WidgetTester tester) async {
      // Arrange
      final repo = FakeEmptyWordRepository();
      final getWords = GetWords(repo);
      final addWord = AddWord(repo);
      final deleteWord = DeleteWord(repo);
      
      final provider = WordsProvider(
        getWordsUseCase: getWords,
        addWordUseCase: addWord,
        deleteWordUseCase: deleteWord,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WordsProvider>.value(
            value: provider..fetchWords(),
            child: const VocabularyScreen(),
          ),
        ),
      );

      await tester.pump(); // Trigger fetch completed state

      // Assert
      expect(find.text("You haven't saved any words yet."), findsOneWidget);
      expect(find.text("Add Your First Word"), findsOneWidget);
    });

    testWidgets('displays word list when words exist', (WidgetTester tester) async {
      // Arrange
      final repo = FakeWordRepository();
      final getWords = GetWords(repo);
      final addWord = AddWord(repo);
      final deleteWord = DeleteWord(repo);
      
      final provider = WordsProvider(
        getWordsUseCase: getWords,
        addWordUseCase: addWord,
        deleteWordUseCase: deleteWord,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<WordsProvider>.value(
            value: provider..fetchWords(),
            child: const VocabularyScreen(),
          ),
        ),
      );

      await tester.pump(); // Trigger fetch completed state

      // Assert
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('A fruit'), findsOneWidget);
      expect(find.text('Manzana'), findsOneWidget);
    });
  });
}
