import 'package:e_comm_tata/screens/product_list/product_list_page.dart';

import '../../utils/landing_page/category_slider_service.dart';
import '../../utils/landing_page/common_service.dart';
import '../../Sanity/sanity_repository.dart';
import 'package:flutter/material.dart';
import '../../utils/landing_page/img_constants.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CategorySlider extends StatefulWidget {
  const CategorySlider({Key? key}) : super(key: key);

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  final ImgConstants imgs = ImgConstants();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      decoration: CommonService(context)
          .decorateBoxCircular(), //makes the container circular
      child: Column(
        children: [
          CommonService(context).alignTextLeft('Categories'),
          const SizedBox(
            height: 5.0,
          ),
          FutureBuilder(
              future: SanityRepository().getAllCategoriesThumbnails(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //show error while waiting for connection
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white70,
                    ),
                  );
                }
                return CarouselSlider(
                  options: CarouselOptions(
                    height: 70,
                    initialPage: 2,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.2,
                  ),

                  //Widget is specified for proper closure of Map function
                  items: snapshot.data
                      .map<Widget>((categoryMeta) => InkWell(
                            onTap: () {
                              // routing to specific categories
                              Navigator.pushNamed(
                                  context, ProductsListPage.routeName,
                                  arguments: {"query": categoryMeta["kind"]});
                            },
                            child: CategorySliderService()
                                .generateCarouselContainer(categoryMeta),
                          ))
                      .toList(),
                );
              })
        ],
      ),
    );
  }
}
