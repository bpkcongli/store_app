class ProductInvalidStateException implements Exception {
  final String cause;

  ProductInvalidStateException(this.cause);
}
