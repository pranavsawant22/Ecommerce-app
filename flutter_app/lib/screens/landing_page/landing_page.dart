import 'package:flutter/material.dart';

import '../../utils/bottom_navbar/bottom_navbar_util.dart';
import '../../utils/bottom_navbar/page_index.dart';
import '../../utils/landing_page/landing_page_service.dart';
import '../../widgets/landing_page/bank_offer_slider.dart';
import '../../widgets/landing_page/category_slider.dart';
import '../../widgets/landing_page/coming_soon.dart';
import '../../widgets/landing_page/deal_slider.dart';
import '../../widgets/landing_page/product_advertisement.dart';
import '../../widgets/landing_page/sidebar.dart';
import '../../widgets/search/search_button.dart';

class LandingPage extends StatelessWidget {
  static String routeName = "/landing";
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: LandingPageService().appBarWithSideBar(),
      body: Container(
        padding: const EdgeInsets.all(6),
        child: ListView(
          children: const <Widget>[
            SearchButton(),
            SizedBox(height: 6),
            CategorySlider(), //shows all the categories available
            SizedBox(height: 6.0),
            DealSlider(), //shows all the deals currently running by the company
            SizedBox(height: 6.0),
            ComingSoonAdvertisement(), //An advert of one upcoming product
            SizedBox(
              height: 5.0,
            ),
            BankOfferSlider(), //Shows all the bank that have special offers running
            SizedBox(height: 6.0),
            ProductAdvertisement(), //A product advert being run by the company
          ],
        ),
      ),
      bottomNavigationBar:
          BottomNavbarUtil(index: pageIndex["landing_page"] as int),
    );
  }
}
