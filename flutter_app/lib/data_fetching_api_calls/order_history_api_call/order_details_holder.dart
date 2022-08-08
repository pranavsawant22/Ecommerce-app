import 'ordered_item_details_holder.dart';

class OrderDetailsHolder {
  String orderId;
  String userId;
  int totalPrice;
  String orderStatus;
  List<OrderedItemDetailsHolder> itemDetails;

  OrderDetailsHolder(
      {required this.orderId,
      required this.userId,
      required this.itemDetails,
      required this.totalPrice,
      required this.orderStatus});
}
