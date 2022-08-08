// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProductShortDescription extends StatelessWidget {
  String description;
  ProductShortDescription({required this.description, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        description,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
