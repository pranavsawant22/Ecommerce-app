import 'package:flutter/material.dart';

class BankOfferSliderService {

  Container generateCarouselContainer(String item){
    return Container(
        margin: const EdgeInsets.only(bottom: 5.0, left: 2.5, right: 2.5),
        child: Image.network(item, fit: BoxFit.cover, width: 1000.0,)
    );
  }
}