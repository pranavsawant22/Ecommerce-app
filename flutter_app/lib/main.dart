import '/screens/splash_screen/splash_screen.dart';

import '/utils/wislist_state_management/wishlist_delete.dart';

import '/utils/cart_checkout/delete_and_quantity_change_ui_update_logic/delete_and_quantity_ui_update_logic_cart.dart';

import 'data_fetching_api_calls/cart_item_api_calls/get_cart_items_api.dart';
import 'data_fetching_api_calls/product_list_api_call/get_product_list_api.dart';
import 'data_fetching_api_calls/wishlist_api_call/get_wishlist.dart';
import 'screens/landing_page/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/routes.dart';

import 'data_fetching_api_calls/cart_item_api_calls/wishlist_cart_api.dart';

import '/sanity_api_call/pdp_sainity_api/pdp_sanity_api.dart';
import 'data_fetching_api_calls/order_history_api_call/get_all_orders_api.dart';
import 'data_fetching_api_calls/pdp_data_fetch_api_call/pdp_add_to_cart_api.dart';
import 'data_fetching_api_calls/review_api_call/add_rating_api.dart';
import 'data_fetching_api_calls/review_api_call/add_review_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GetAllOrderAPI(),
        ),
        ChangeNotifierProvider(
          create: (_) => GetCartItemsAPI(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddReviewAPI(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddRatingAPI(),
        ),
        ChangeNotifierProvider(
          create: (_) => PDPSanityAPI(),
        ),
        ChangeNotifierProvider(
          create: (_) => PdpAddToCartApi(),
        ),
        ChangeNotifierProvider(
          create: (_) => GetWishlistAPI(),
        ),
        ChangeNotifierProvider(
          create: (_) => GetProductListAPI(),
        ),
        ChangeNotifierProvider(
          create: (_) => DeleteQuantityChangeUiUpdate(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishListDelete(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff222831),
            centerTitle: true,
          ),
          colorScheme: const ColorScheme.dark().copyWith(
            primary: const Color(0xff222831),
            secondary: const Color(0xff393E46),
            tertiary: const Color(0xff00ADB5),
          ),
          textTheme: const TextTheme(
            headline1: TextStyle(color: Colors.white),
          ),
          scaffoldBackgroundColor: const Color(0xff222831),
        ),
        routes: routes,
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
