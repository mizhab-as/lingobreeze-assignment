import '../../../../core/usecases/usecase.dart';
import '../entities/word.dart';
import '../repositories/word_repository.dart';

class AddWordParams {
  final String word;
  final String meaning;
  final String translation;

  const AddWordParams({
    required this.word,
    required this.meaning,
    required this.translation,
  });
}

class AddWord implements UseCase<Word, AddWordParams> {
  final WordRepository repository;

  AddWord(this.repository);

  @override
  Future<Word> call(AddWordParams params) async {
    return await repository.addWord(
      params.word,
      params.meaning,
      params.translation,
    );
  }
}
