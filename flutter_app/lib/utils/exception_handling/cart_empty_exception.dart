class CartEmptyException implements Exception {
  String cause;
  CartEmptyException(this.cause);
}
