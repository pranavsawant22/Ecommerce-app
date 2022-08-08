import 'wishlist_item_details_holder.dart';

class WishlistDetailsHolder {
  String id;
  String userid;
  List<WishlistItemDetailsHolder> wishlistitems;

  WishlistDetailsHolder({ required this.id,
    required this.userid,
    required this.wishlistitems,
  }
        );
}
