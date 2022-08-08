// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductLongDescription extends StatelessWidget {
  String description;
  ProductLongDescription({required this.description, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          description,
          style: TextStyle(fontSize: 20),
        ),
      ),
      width: double.infinity,
      alignment: Alignment.center,
    );
  }
}
