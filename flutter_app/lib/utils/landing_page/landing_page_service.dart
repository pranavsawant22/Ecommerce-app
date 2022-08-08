import 'package:flutter/material.dart';

class LandingPageService {
  AppBar appBarWithSideBar() {
    return AppBar(
      title: const Text('The Neu Store'),
    );
  }

  BottomNavigationBar bottomNavBar() {
    return BottomNavigationBar(
      // type: BottomNavigationBarType.shifting,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.grey,
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.grey,
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.grey,
          icon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
      ],
      selectedItemColor: Colors.black,
    );
  }
}
