// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductHeading extends StatelessWidget {
  String productName;
  String ratingAvg;
  ProductHeading({required this.ratingAvg, required this.productName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.60,
          child: Text(
            productName,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Text(
              ratingAvg,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.star),
          ],
        ),
      ],
    );
  }
}
