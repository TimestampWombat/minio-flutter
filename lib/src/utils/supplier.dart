typedef Supplier<T> = T Function();

extension SupplierX<T> on Supplier<T> {
  T get() => this.call();
}
