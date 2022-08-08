import 'package:e_comm_tata/screens/product_list/product_list_page.dart';
import 'package:e_comm_tata/widgets/search/pill_button.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  static const categories = [
    'SmartPhone',
    'TV',
    'Laptop',
    'Apparels',
    'Trouser',
    'Shoes',
    'Fiction',
    'Non Fiction',
    'Educational'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Discover more",
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: GridView.count(
              childAspectRatio: 2,
              crossAxisCount: 3,
              children: categories
                  .map((category) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: PillButton(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          buttonText: category,
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, ProductsListPage.routeName,
                                arguments: {
                                  'type': 'category',
                                  'query': category
                                });
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
