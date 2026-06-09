class Word {
  final String id;
  final String word;
  final String meaning;
  final String translation;
  final String? createdAt;

  Word({required this.id, required this.word, required this.meaning, required this.translation, this.createdAt});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id']?.toString() ?? '',
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
      translation: json['translation'] ?? '',
      createdAt: json['createdAt'],
    );
  }
}
