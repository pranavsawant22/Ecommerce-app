import '/screens/splash_screen/splash_screen.dart';

import '/screens/cart_checkout/cart_screen.dart';
import '/screens/cart_checkout/checkout_screen.dart';
import '/screens/product_list/product_list_page.dart';
import '/screens/user_profile/profile_screen.dart';
import 'package:flutter/widgets.dart';

import './screens/auth/change_password_screen.dart';
import './screens/auth/complete_profile_screen.dart';
import './screens/auth/forgot_password_screen.dart';
import './screens/auth/otp_screen.dart';
import './screens/auth/sign_in_screen.dart';
import './screens/auth/sign_up_screen.dart';
import './screens/landing_page/landing_page.dart';
import './screens/order_history/order_history_page.dart';
import './screens/product_details/product_detail_page.dart';
import 'screens/search/search_screen.dart';
import './screens/wishlist/empty_wishlist_page.dart';
import './screens/wishlist/wish_list.dart';

final Map<String, WidgetBuilder> routes = {
  ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  OtpScreen.routeName1: (context) => OtpScreen(
        screen: 1,
      ), //Otp screen that opens Login page
  OtpScreen.routeName2: (context) => OtpScreen(
        screen: 2,
      ), // Otp screen that opens change password page
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  LandingPage.routeName: (context) => LandingPage(),
  OrderHistory.routeName: (context) => OrderHistory(),
  ProductDetails.routeName: (context) => ProductDetails(),
  SearchScreen.routeName: (context) => const SearchScreen(),
  Wishlist.routeName: (context) => Wishlist(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  CheckoutScreen.routeName: (context) => CheckoutScreen(),
  EmptyWishListScreen.routeName: (context) => EmptyWishListScreen(),
  ProductsListPage.routeName: (context) => ProductsListPage(),
  SplashScreen.routeName: (context) => SplashScreen(),
};
