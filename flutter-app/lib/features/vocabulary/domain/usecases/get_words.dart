import '../../../../core/usecases/usecase.dart';
import '../entities/word.dart';
import '../repositories/word_repository.dart';

class GetWords implements UseCase<List<Word>, NoParams> {
  final WordRepository repository;

  GetWords(this.repository);

  @override
  Future<List<Word>> call(NoParams params) async {
    return await repository.getWords();
  }
}
