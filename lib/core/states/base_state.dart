sealed class BaseState<T> {}

class BaseStateInitial<T> extends BaseState<T> {}

class BaseStateLoading<T> extends BaseState<T> {}

class BaseStateSuccess<T> extends BaseState<T> {
  final T data;
  BaseStateSuccess(this.data);
}

class BaseStateError<T> extends BaseState<T> {
  final String message;
  BaseStateError(this.message);
}

extension BaseStateExtension<T> on BaseState<T> {
  String? get message {
    if (this is BaseStateError<T>) {
      return (this as BaseStateError<T>).message;
    }
    return null;
  }

  bool get isLoading => this is BaseStateLoading<T>;
  bool get isError => this is BaseStateError<T>;
  bool get isSuccess => this is BaseStateSuccess<T>;
  bool get isInitial => this is BaseStateInitial<T>;

  T? get data {
    if (this is BaseStateSuccess<T>) {
      return (this as BaseStateSuccess<T>).data;
    }
    return null;
  }
}