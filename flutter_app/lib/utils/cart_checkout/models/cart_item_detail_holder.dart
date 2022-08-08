class CartItemsDetailsHolder {
  String cartitemId;
  String skuId;
  int quantity;
  String productName;
  String imageUrl;
  double price;
  int countInStock;

  CartItemsDetailsHolder(
      {required this.countInStock,
      required this.price,
      required this.imageUrl,
      required this.productName,
      required this.cartitemId,
      required this.quantity,
      required this.skuId});
}
