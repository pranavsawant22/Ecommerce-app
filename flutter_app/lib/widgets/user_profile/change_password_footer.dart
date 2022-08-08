import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FooterButton extends StatelessWidget {
  FooterButton({required this.s1,Key? key}) : super(key: key);
  String s1;
  @override
  Widget build(BuildContext context) {
    return
      // ExpansionTile(
      //   trailing: Icon(null),
      // expandedAlignment: Alignment.center,
      // title:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListTile(
          title: Center(child: Text(s1, style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w600))),
          onTap: () => null,

          // leading: icon,

        ),
      );
  }
}
