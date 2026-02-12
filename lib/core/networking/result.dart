sealed class Result<T> {}

class Success<T> extends Result<T> {
  Success(this.value);
  T value;
}

class ErrorState<T> extends Result<T> {
  ErrorState(this.error);
  String error;
}


/*
Result<int> pasrsing(String input) {
  try {
    int value = int.parse(input);
    return Success<int>(value);
  } catch (e) {
    return ErrorState<int>(e.toString());
  }
}
*/