class WishlistItemDetailsHolder {
  String id;
  String skuId;
  String imageUrl;
  String name;
  int countInStock;

  double price;

  WishlistItemDetailsHolder({
    required this.price,
    required this.id,
    required this.skuId,
    required this.imageUrl,
    required this.name,
    required this.countInStock,
  });
}
