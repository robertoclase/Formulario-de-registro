class Result<T, E> {
  final T? _success;
  final E? _error;
  final bool _isSuccess;

  const Result._(this._success, this._error, this._isSuccess);

  factory Result.success(T value) => Result._(value, null, true);
  factory Result.error(E error) => Result._(null, error, false);

  bool get isSuccess => _isSuccess;
  bool get isError => !_isSuccess;

  T get value {
    if (!isSuccess) throw StateError('Trying to get value from error result');
    return _success!;
  }

  E get error {
    if (isSuccess) throw StateError('Trying to get error from success result');
    return _error!;
  }

  Result<R, E> map<R>(R Function(T) mapper) {
    if (isSuccess) {
      try {
        return Result.success(mapper(value));
      } catch (e) {
        return Result.error(e as E);
      }
    }
    return Result.error(error);
  }

  Result<T, R> mapError<R>(R Function(E) mapper) {
    if (isError) {
      return Result.error(mapper(error));
    }
    return Result.success(value);
  }

  @override
  String toString() {
    return isSuccess ? 'Success($value)' : 'Error($error)';
  }
}