// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenuExpandedOptions extends StatelessWidget {
  SideMenuExpandedOptions(
      {required this.icon, required this.s1, required this.options, Key? key})
      : super(key: key);
  Icon icon;
  String s1;
  List<String> options;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedIconColor: Colors.white,
      expandedAlignment: Alignment.center,
      children: options
          .map((e) => TextButton(
              onPressed: () {
                // redirect(e);
              },
              child: Text(e,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.normal))))
          .toList(),
      title: ListTile(
        leading: icon,
        title: Text(s1,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class SideMenuExpanded extends StatelessWidget {
  SideMenuExpanded({required this.icon, required this.s1, Key? key})
      : super(key: key);
  Icon icon;
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
        leading: icon,
        title: Text(s1,
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600)),

        // leading: icon,
      ),
    );
  }
}
