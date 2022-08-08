import 'package:e_comm_tata/screens/product_details/product_detail_page.dart';

import '../../utils/landing_page/common_service.dart';
import '../../utils/landing_page/img_constants.dart';
import '../../Sanity/sanity_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ImgConstants imgs = ImgConstants();

class ProductAdvertisement extends StatelessWidget {
  const ProductAdvertisement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: CommonService(context)
          .decorateBoxCircular(), // makes the container circular
      margin: const EdgeInsets.only(bottom: 5.0),
      child: Column(children: <Widget>[
        CommonService(context).alignTextLeft('New Product Release'),
        const SizedBox(
          height: 5.0,
        ),
        FutureBuilder(
            future: SanityRepository().getProductAdImage(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return InkWell(
                  onTap: () {
                    //ToDo: replace with routing to product details page
                    // Navigator.pushNamed(context, ProductDetails.routeName,
                    //     arguments: {
                    //       "type": "advertisement",
                    //       "data": snapshot.data
                    //     });
                    //will require context
                    if (kDebugMode) {}
                  },
                  child: Image.network(
                    snapshot.data['imageUrl'],
                    width: 1000,
                    fit: BoxFit.fitHeight,
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white70,
                  ),
                );
              }
            }),
      ]),
    );
  }
}
