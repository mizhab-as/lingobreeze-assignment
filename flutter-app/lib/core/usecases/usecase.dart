import 'package:provider/provider.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {
  const NoParams();
}
