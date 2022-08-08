import 'package:flutter/material.dart';

class CommonService {
  final BuildContext context;

  CommonService(this.context);
  Align alignTextLeft(String inputText) {
    //Aligns the input text to left
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(inputText),
    );
  }

  BoxDecoration decorateBoxCircular() {
    return BoxDecoration(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(8.0),
    );
  }
}
