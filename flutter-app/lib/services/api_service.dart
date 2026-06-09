import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word.dart';
import '../config.dart';

class ApiService {
  final String baseUrl;
  ApiService({this.baseUrl = BACKEND_BASE_URL});

  Future<List<Word>> fetchWords() async {
    final res = await http.get(Uri.parse('$baseUrl/words'));
    if (res.statusCode != 200) throw Exception('Failed to load words');
    final List data = json.decode(res.body) as List;
    return data.map((e) => Word.fromJson(e)).toList();
  }

  Future<Word> addWord(String word, String meaning, String translation) async {
    final res = await http.post(Uri.parse('$baseUrl/words'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'word': word, 'meaning': meaning, 'translation': translation}));
    if (res.statusCode != 201) throw Exception('Failed to save word');
    final Map<String, dynamic> data = json.decode(res.body);
    return Word.fromJson(data);
  }
}
