import 'package:e_comm_tata/screens/auth/sign_up_screen.dart';
import 'package:e_comm_tata/screens/landing_page/landing_page.dart';
import 'package:e_comm_tata/screens/user_profile/profile_screen.dart';
import 'package:e_comm_tata/screens/wishlist/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';


import '../../data_fetching_api_calls/check_user_logged_in_api_call/check_user_logged_in.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/cart_checkout/cart_screen.dart';

class BottomNavbarUtil extends StatefulWidget {
  int index;

  BottomNavbarUtil({required this.index});

  @override
  State<BottomNavbarUtil> createState() => _BottomNavbarUtilState();
}

class _BottomNavbarUtilState extends State<BottomNavbarUtil> {
  navigationRoute(int routedIndex, BuildContext context, int prevIndex) {
    if (prevIndex != routedIndex) {
      if (routedIndex == 0) {
        Navigator.of(context).pushReplacementNamed(LandingPage.routeName);
      }
      if (routedIndex == 1) {
        Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
      }
      if (routedIndex == 2) {
        Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
      }
      if (routedIndex == 3) {
        Navigator.of(context).pushReplacementNamed(Wishlist.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SnakeNavigationBar.color(
      backgroundColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.white,
      selectedItemColor: Theme.of(context).colorScheme.tertiary,
      snakeViewColor: Theme.of(context).colorScheme.tertiary,
      behaviour: SnakeBarBehaviour.pinned,
      snakeShape: SnakeShape.indicator,
      shape: null,
      padding: EdgeInsets.zero,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      // type: BottomNavigationBarType.shifting,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
      ],
      currentIndex: widget.index,
      onTap: (int routedIndex) async {
        //check if user logged in
        //if not redirect to login screen
        bool checkUserLogIn = await CheckUserLoggedInAPI.checkUserLogInAPICall();
        if(checkUserLogIn) {
          navigationRoute(routedIndex, context, widget.index);
        }
        else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            SignInScreen.routeName,
            ModalRoute.withName(SignInScreen.routeName),
          );
        }
      },
    );
  }
}
