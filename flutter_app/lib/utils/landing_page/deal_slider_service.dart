import 'package:flutter/material.dart';

class DealSliderService {
  Container generateCarouselContainer(String imageUrl) {
    return Container(
      color: Colors.green.shade100,
      margin: const EdgeInsets.only(bottom: 5.0, left: 2.5, right: 2.5),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
            width: 1000.0,
          )),
    );
  }
}
