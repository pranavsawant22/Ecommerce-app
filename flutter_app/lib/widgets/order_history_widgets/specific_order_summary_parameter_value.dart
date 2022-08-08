// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

//Widget for Parameters related to specific orders
//Like the icons, order parameters: order id, date, items
//order values like the id, date, quantity
class SpecificOrderSummaryParameterValue extends StatelessWidget {
  Icon icon;
  String orderParameter;
  String orderParameterValue;

  SpecificOrderSummaryParameterValue(
      {required this.icon,
      required this.orderParameter,
      required this.orderParameterValue});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            icon,
            SizedBox(
              width: 20,
            ),
            Text(orderParameter,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                )),
          ],
        ),
        Text(orderParameterValue,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
            ))
      ],
    );
  }
}
