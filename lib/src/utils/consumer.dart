typedef Consumer<T> = void Function(T t);

extension ConsumerX<T> on Consumer<T> {
  void accept(T t) => this.call(t);

  Consumer<T> andThen(Consumer<T> after) {
    return (T t) {
      this.accept(t);
      after.accept(t);
    };
  }
}
