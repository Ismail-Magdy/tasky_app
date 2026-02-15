sealed class Result<T> {}

class Success<T> extends Result<T> {
  T value;

  Success(this.value);
}

class ErrorState<T> extends Result<T> {
  String error;

  ErrorState(this.error);
}
