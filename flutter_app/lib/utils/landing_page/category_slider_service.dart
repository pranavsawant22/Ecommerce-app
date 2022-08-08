import 'package:flutter/material.dart';

class CategorySliderService {
  Container generateCarouselContainer(categoryMeta) {
    /// generates a container for the carousel in category slider

    return Container(
      margin: const EdgeInsets.only(bottom: 5.0, left: 2.5, right: 2.5),
      child: Column(children: <Widget>[
        Image.network(
          categoryMeta['imageUrl'].toString(),
          fit: BoxFit.fill,
          height: 50,
          width: 50,
        ),
        Text(
          categoryMeta['kind'].toString(),
          style: const TextStyle(
            fontSize: 10,
          ),
        )
      ]),
    );
  }
}
