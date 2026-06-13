import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config.dart';
import '../models/word_model.dart';
import 'word_remote_data_source.dart';

class WordRemoteDataSourceImpl implements WordRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  WordRemoteDataSourceImpl({
    http.Client? client,
    this.baseUrl = BACKEND_BASE_URL,
  }) : client = client ?? http.Client();

  @override
  Future<List<WordModel>> getWords() async {
    final response = await client.get(
      Uri.parse('$baseUrl/words'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body) as List;
      return decoded.map((e) => WordModel.fromJson(e)).toList();
    } else {
      throw Exception('Server returned status code: ${response.statusCode}');
    }
  }

  @override
  Future<WordModel> addWord(String word, String meaning, String translation) async {
    final response = await client.post(
      Uri.parse('$baseUrl/words'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'word': word,
        'meaning': meaning,
        'translation': translation,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> decoded = json.decode(response.body);
      return WordModel.fromJson(decoded);
    } else {
      throw Exception('Server returned status code: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteWord(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/words/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Server returned status code: ${response.statusCode}');
    }
  }
}
