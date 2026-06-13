import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lingo_breeze/features/vocabulary/data/datasources/word_remote_data_source_impl.dart';
import 'package:lingo_breeze/features/vocabulary/data/models/word_model.dart';

void main() {
  group('WordRemoteDataSourceImpl', () {
    test('getWords should return List<WordModel> when status code is 200', () async {
      // Arrange
      final responseBody = [
        {
          'id': '1',
          'word': 'Apple',
          'meaning': 'A fruit',
          'translation': 'Manzana',
          'createdAt': '2026-06-13T12:00:00Z',
        }
      ];

      final mockClient = MockClient((request) async {
        return http.Response(json.encode(responseBody), 200);
      });

      final dataSource = WordRemoteDataSourceImpl(client: mockClient, baseUrl: 'http://test-url.local');

      // Act
      final result = await dataSource.getWords();

      // Assert
      expect(result, isA<List<WordModel>>());
      expect(result.length, 1);
      expect(result.first.word, 'Apple');
    });

    test('getWords should throw Exception when status code is not 200', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Error', 500);
      });

      final dataSource = WordRemoteDataSourceImpl(client: mockClient, baseUrl: 'http://test-url.local');

      // Act & Assert
      expect(() => dataSource.getWords(), throwsException);
    });

    test('addWord should return WordModel when status code is 201', () async {
      // Arrange
      final responseBody = {
        'id': '2',
        'word': 'Beautiful',
        'meaning': 'Pleasing to look at',
        'translation': 'Hermosa',
        'createdAt': '2026-06-13T12:05:00Z',
      };

      final mockClient = MockClient((request) async {
        return http.Response(json.encode(responseBody), 201);
      });

      final dataSource = WordRemoteDataSourceImpl(client: mockClient, baseUrl: 'http://test-url.local');

      // Act
      final result = await dataSource.addWord('Beautiful', 'Pleasing to look at', 'Hermosa');

      // Assert
      expect(result, isA<WordModel>());
      expect(result.id, '2');
      expect(result.word, 'Beautiful');
    });

    test('addWord should throw Exception when status code is not 201', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Error', 400);
      });

      final dataSource = WordRemoteDataSourceImpl(client: mockClient, baseUrl: 'http://test-url.local');

      // Act & Assert
      expect(
        () => dataSource.addWord('Beautiful', 'Pleasing to look at', 'Hermosa'),
        throwsException,
      );
    });

    test('deleteWord should succeed when status code is 200', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('{"success": true}', 200);
      });

      final dataSource = WordRemoteDataSourceImpl(client: mockClient, baseUrl: 'http://test-url.local');

      // Act & Assert
      await dataSource.deleteWord('1');
    });

    test('deleteWord should throw Exception when status code is not 200', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Error', 404);
      });

      final dataSource = WordRemoteDataSourceImpl(client: mockClient, baseUrl: 'http://test-url.local');

      // Act & Assert
      expect(
        () => dataSource.deleteWord('1'),
        throwsException,
      );
    });
  });
}
