// import 'package:e_comm_tata/widgets/cart_checkout/cart_checkout_product_items.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../data_fetching_api_calls/cart_item_api_calls/delete_cart_api.dart';
// import '../size_config.dart';
// import 'Cart.dart';
//
//
// class CartCheckoutBody extends StatefulWidget {
//   @override
//   _CartCheckoutBodyState createState() => _CartCheckoutBodyState();
// }
//
// class _CartCheckoutBodyState extends State<CartCheckoutBody> {
//   @override
//   Widget build(BuildContext context) {
//     // final getCartItemAPIProvider = Provider.of<GetCartItemsAPI>(context, listen: false);
//
//     // getdata();
//     SizeConfig().init(context);
//     return FutureBuilder(
//         future: DeleteCartItemsAPI.getcartapicall(),
//         // future: getCartItemAPIProvider.getcartapicall(),
//         builder: (context, AsyncSnapshot<CartDetailsHolder?> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           else if(snapshot.hasData) {
//             return Padding(
//               padding:
//               EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
//               child: ListView.builder(
//                 itemCount: snapshot.data!.itemDetails.length,
//
//                 itemBuilder: (context, index) =>
//                     Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//
//                       child: CartCheckoutProductItems(cart: snapshot.data!.itemDetails[index]),
//                     ),
//               ),
//             );
//           }
//           else if (snapshot.hasError)
//           {
//             var error = snapshot.error;
//             return Text('$error');
//           }
//           else {
//             // Fprint(snapshot.data.itemDetails);
//             return Text('Nothing');
//
//
//           };
//         }
//     );
//   }
// }
//
