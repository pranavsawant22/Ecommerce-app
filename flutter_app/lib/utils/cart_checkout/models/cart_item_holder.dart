import '../models/cart_item_detail_holder.dart';

class CartDetailsHolder {
  String Id;
  String userId;
  //int totalPrice;
  List<CartItemsDetailsHolder> itemDetails;

  CartDetailsHolder({
    required this.Id,
    required this.userId,
    required this.itemDetails,
    //required this.totalPrice,
  });
}
