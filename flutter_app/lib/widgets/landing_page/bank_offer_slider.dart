import '../../utils/landing_page/bank_offer_slider_service.dart';
import '../../utils/landing_page/common_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../utils/landing_page/img_constants.dart';
import '../../Sanity/sanity_repository.dart';

ImgConstants imgs = ImgConstants(); // gets image constants

class BankOfferSlider extends StatelessWidget {
  const BankOfferSlider({Key? key}) : super(key: key);

  /// This class generates the bank offer carousel

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration:
          CommonService(context).decorateBoxCircular(), //makes the container circular
      child: Column(
        children: [
          CommonService(context).alignTextLeft('Bank Offers'),
          const SizedBox(
            height: 5.0,
          ),
          FutureBuilder(
            future: SanityRepository().getBankOfferImage(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white70,
                  ),
                );
              }
              return CarouselSlider(
                options: CarouselOptions(
                  height: 125.0,
                  viewportFraction: 0.5,
                ),
                items: snapshot.data
                    .map<Widget>(
                      (item) => BankOfferSliderService()
                          .generateCarouselContainer(item),
                    )
                    .toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
