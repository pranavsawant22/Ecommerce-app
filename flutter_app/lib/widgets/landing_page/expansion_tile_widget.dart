import 'package:flutter/material.dart';

class SideMenuExpandedOptions extends StatelessWidget {
  SideMenuExpandedOptions(
      {required this.icon, required this.s1, required this.options, Key? key})
      : super(key: key);
  Icon icon;
  String s1;
  List<Widget> options;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedTextColor: Colors.white,
      textColor: Colors.white,
      expandedAlignment: Alignment.center,
      title: ListTile(
        leading: icon,
        title: Text(
          s1,
          style: TextStyle(color: Colors.white),
        ),
      ),
      children: options,
    );
  }
}
