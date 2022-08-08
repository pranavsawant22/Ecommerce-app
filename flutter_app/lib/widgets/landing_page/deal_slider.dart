import 'package:carousel_slider/carousel_slider.dart';
import '../../screens/product_list/product_list_page.dart';
import '../../utils/landing_page/common_service.dart';
import '../../Sanity/sanity_repository.dart';
import 'package:flutter/material.dart';
import '../../utils/landing_page/deal_slider_service.dart';

class DealSlider extends StatefulWidget {
  const DealSlider({Key? key}) : super(key: key);

  @override
  State<DealSlider> createState() => _DealSliderState();
}

class _DealSliderState extends State<DealSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          CommonService(context).alignTextLeft('Special Deals'),
          const SizedBox(
            height: 5.0,
          ),
          FutureBuilder(
              future: SanityRepository().getAllSpecialDeals(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //display icon while waiting
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white70,
                    ),
                  );
                }
                return CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                    ),

                    //Widget is required for map for proper casting
                    items: snapshot.data.map<Widget>((sliderMeta) {
                      return InkWell(
                          onTap: () {
                            //ToDo: replace with routing to actual category page
                            Navigator.pushNamed(
                                context, ProductsListPage.routeName,
                                arguments: {
                                  "query": sliderMeta["categoryName"]
                                });
                          },
                          child: DealSliderService().generateCarouselContainer(
                              sliderMeta['imageUrl']));
                    }).toList());
              })
        ],
      ),
    );
  }
}
