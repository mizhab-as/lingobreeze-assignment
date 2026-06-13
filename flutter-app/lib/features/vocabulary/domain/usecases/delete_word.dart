import '../../../../core/usecases/usecase.dart';
import '../repositories/word_repository.dart';

class DeleteWord implements UseCase<void, String> {
  final WordRepository repository;

  DeleteWord(this.repository);

  @override
  Future<void> call(String id) async {
    await repository.deleteWord(id);
  }
}
