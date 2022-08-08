// ignore_for_file: prefer_const_constructors

import 'package:e_comm_tata/data_fetching_api_calls/product_list_api_call/get_product_list_api.dart';
import 'package:e_comm_tata/data_fetching_api_calls/product_list_api_call/typesense_data_holder_model.dart';
import 'package:e_comm_tata/screens/product_details/product_detail_page.dart';
import 'package:e_comm_tata/utils/cart_checkout/Product.dart';
import 'package:e_comm_tata/utils/exception_handling/CustomException.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_fetching_api_calls/product_list_api_call/product_list.dart';
import 'products_list_items.dart';

class ProductsListPage extends StatefulWidget {
  static String routeName = '/product_list';
  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  late BuildContext context;

  //Default value that shows on drop down menu
  String dropdownvalue = 'PRICE: Low To High';
  String parameterValue = "price";
  String arrangementOrder = "asc";
  // List of items in our dropdown menu
  var items = [
    'PRICE: Low To High',
    'PRICE: High To Low',
    'RATING: High To Low ',
  ];
  String categoryData = "";
  @override
  Widget build(BuildContext context) {
    this.context = context;
    final category =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (category != null) {
      categoryData = category["query"];
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            child: _buildFilterButton('filter'),
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GetProductListAPI>(context)
            .fetchProductList(categoryData, parameterValue, arrangementOrder),
        builder:
            (context, AsyncSnapshot<List<TypeSenseDataHolderModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (snapshot.hasError) {
            final error = snapshot.error as CustomException;
            return Center(child: Text(error.cause));
          }
          if (snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return Center(
                child: Text(
                  "No Products Found",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }

            return GridView.builder(
                primary: true,
                itemCount: snapshot.data!.length,
                // padding: const EdgeInsets.all(5),
                // crossAxisSpacing: 10,
                // mainAxisSpacing: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.7,
                  crossAxisCount: 2,
                ),
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(ProductDetails.routeName,
                          arguments: {
                            "type": 'productListPage',
                            "data": snapshot.data![index]
                          });
                    },
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          child: Image.network(snapshot.data![index].imageUrl,
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        child: ListTile(
                          onTap: () {},
                          title: Text(snapshot.data![index].productSkuName),
                          subtitle: Text(snapshot.data![index].price),
                        ),
                      )
                    ]),
                  );
                });
          } else {
            return Text(
              "No data",
              style: TextStyle(color: Colors.white),
            );
          }
        },
      ),
    );
  }

  _buildFilterWidgets(Size screenSize) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      width: screenSize.width,
      child: Card(
        elevation: 4.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildFilterButton(
                "FILTER",
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildFilterButton(
    String title,
  ) {
    return InkWell(
      onTap: () {
        //Navigator.of(context).pushNamed(Constants.ROUTE_FILTER);
      },
      child: DropdownButton(
        value: dropdownvalue,

        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),

        // Array list of items
        items: items.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value

        onChanged: (String? newValue) {
          setState(() {
            dropdownvalue = newValue!;
            if (dropdownvalue == "PRICE: Low To High") {
              parameterValue = "price";
              arrangementOrder = "asc";
            } else if (dropdownvalue == "PRICE: High To Low") {
              parameterValue = "price";
              arrangementOrder = "desc";
            } else {
              parameterValue = "rating";
              arrangementOrder = "desc";
            }
          });
        },
      ),
    );
  }

  _dummyProductsList() {
    return [
      const ProductsListItem(
        name: "Michael Kora",
        currentPrice: 524,
        originalPrice: 699,
        discount: 25,
        imageUrl:
            "https://n1.sdlcdn.com/imgs/c/9/8/Lambency-Brown-Solid-Casual-Blazers-SDL781227769-1-1b660.jpg",
      ),
      const ProductsListItem(
        name: "Michael Kora",
        currentPrice: 524,
        originalPrice: 699,
        discount: 25,
        imageUrl:
            "https://n1.sdlcdn.com/imgs/c/9/8/Lambency-Brown-Solid-Casual-Blazers-SDL781227769-1-1b660.jpg",
      ),
      const ProductsListItem(
        name: "David Klin",
        currentPrice: 249,
        originalPrice: 499,
        discount: 50,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/71O0zS0DT0L._UX342_.jpg",
      ),
      const ProductsListItem(
        name: "Nakkana",
        currentPrice: 899,
        originalPrice: 1299,
        discount: 23,
        imageUrl:
            "https://assets.myntassets.com/h_240,q_90,w_180/v1/assets/images/1304671/2016/4/14/11460624898615-Hancock-Men-Shirts-8481460624898035-1_mini.jpg",
      ),
      const ProductsListItem(
        name: "David Klin",
        currentPrice: 249,
        originalPrice: 499,
        discount: 20,
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/71O0zS0DT0L._UX342_.jpg",
      ),
      const ProductsListItem(
        name: "Nakkana",
        currentPrice: 899,
        originalPrice: 1299,
        discount: 23,
        imageUrl:
            "https://assets.myntassets.com/h_240,q_90,w_180/v1/assets/images/1304671/2016/4/14/11460624898615-Hancock-Men-Shirts-8481460624898035-1_mini.jpg",
      ),
    ];
  }
}
