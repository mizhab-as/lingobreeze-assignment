import '../../domain/entities/word.dart';

class WordModel extends Word {
  const WordModel({
    required super.id,
    required super.word,
    required super.meaning,
    required super.translation,
    super.createdAt,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id']?.toString() ?? '',
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
      translation: json['translation'] ?? '',
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'translation': translation,
      'createdAt': createdAt,
    };
  }
}
