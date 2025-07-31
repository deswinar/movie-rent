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
