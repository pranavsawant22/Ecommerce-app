// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:e_comm_tata/data_fetching_api_calls/product_list_api_call/typesense_data_holder_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../sanity_api_call/pdp_sainity_api/pdp_sanity_api.dart';
import '../../widgets/product_detail_page/floating_action_buttons.dart';
import '../../widgets/product_detail_page/product_detail_lower.dart';
import '../../widgets/product_detail_page/product_image_display.dart';

class ProductDetails extends StatelessWidget {
  static String routeName = "/product_details";
  ProductDetails({Key? key}) : super(key: key);

  Map<String, dynamic> productData = {};

  @override
  Widget build(BuildContext context) {
    late TypeSenseDataHolderModel productDataObject;

    final productDataRoute =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (productDataRoute["type"] == "productListPage") {
      productDataObject = productDataRoute["data"] as TypeSenseDataHolderModel;
    }
    final pdpSanityApiProvider =
        Provider.of<PDPSanityAPI>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: FutureBuilder(
          future: pdpSanityApiProvider.pdpSanityProductDetailsApi(
              productDataObject.kind, productDataObject.slug, true),
          builder:
              (BuildContext ctx, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white70,
                ),
              );
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              productData = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ProductImageDisplay(productDataObject.imageUrl),
                    ProductDetailLower(snapshot.data!),
                  ],
                ),
              );
            } else {
              return Text("No data");
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Consumer<PDPSanityAPI>(
            builder: (BuildContext ctx, snapshot, child) {
          return FloatingActionButtons(productData);
        }),
      ),
    );
  }
}
