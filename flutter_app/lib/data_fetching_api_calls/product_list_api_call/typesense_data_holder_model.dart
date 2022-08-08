class TypeSenseDataHolderModel {
  String name;
  String description;
  String brand;
  String rating;
  String kind;
  String productSkuName;
  String price;
  String imageUrl;
  String slug;
  String gender;

  TypeSenseDataHolderModel(
      {required this.name,
      required this.rating,
      required this.price,
      required this.description,
      required this.brand,
      required this.gender,
      required this.imageUrl,
      required this.kind,
      required this.productSkuName,
      required this.slug});
}
