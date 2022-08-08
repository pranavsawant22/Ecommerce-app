class OrderedItemDetailsHolder {
  String itemId;
  String skuId;
  int price;
  String imageUrl;
  String productName;
  int quantity;

  OrderedItemDetailsHolder(
      {required this.quantity,
      required this.productName,
      required this.imageUrl,
      required this.itemId,
      required this.price,
      required this.skuId});
}
