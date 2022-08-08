import 'package:flutter/material.dart';

class AppBarConst extends StatelessWidget {
  const AppBarConst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        //TODO : on pressed function link to the sidebar page
        icon: const Icon(Icons.menu),
        onPressed: () {}, //Sidebar
      ),
      title: const Text('E-comm-app'),
    );
  }
}
