import 'package:flutter/material.dart';

class ProductImageDisplay extends StatelessWidget {
  String imageUrl;
  ProductImageDisplay(this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.60,
      child: Image.network(
        imageUrl,
      ),
    );
  }
}
