abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'A server error occurred. Please try again.']) : super(message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([String message = 'No internet connection. Please check your network.']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache operation failed.']) : super(message);
}
