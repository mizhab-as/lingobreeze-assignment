import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_breeze/features/vocabulary/data/models/word_model.dart';
import 'package:lingo_breeze/features/vocabulary/domain/entities/word.dart';

void main() {
  const tWordModel = WordModel(
    id: '1',
    word: 'Apple',
    meaning: 'A fruit',
    translation: 'Manzana',
    createdAt: '2026-06-13T12:00:00Z',
  );

  group('WordModel', () {
    test('should be a subclass of Word entity', () {
      expect(tWordModel, isA<Word>());
    });

    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        'id': '1',
        'word': 'Apple',
        'meaning': 'A fruit',
        'translation': 'Manzana',
        'createdAt': '2026-06-13T12:00:00Z',
      };

      final result = WordModel.fromJson(jsonMap);

      expect(result, equals(tWordModel));
    });

    test('should return a JSON map containing the proper data', () {
      final result = tWordModel.toJson();

      final expectedJsonMap = {
        'id': '1',
        'word': 'Apple',
        'meaning': 'A fruit',
        'translation': 'Manzana',
        'createdAt': '2026-06-13T12:00:00Z',
      };

      expect(result, equals(expectedJsonMap));
    });
  });
}
