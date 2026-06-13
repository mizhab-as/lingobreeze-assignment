class Word {
  final String id;
  final String word;
  final String meaning;
  final String translation;
  final String? createdAt;

  const Word({
    required this.id,
    required this.word,
    required this.meaning,
    required this.translation,
    this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Word &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          word == other.word &&
          meaning == other.meaning &&
          translation == other.translation &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      word.hashCode ^
      meaning.hashCode ^
      translation.hashCode ^
      createdAt.hashCode;
}
