import 'package:flutter/material.dart';

import '../../screens/search/search_screen.dart';

// Search button
// [double.infinity] width
// onTap -> pushes search screen on top
// Pass product name in productName parameter to display in the search bar

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key, this.productName}) : super(key: key);
  final String? productName;

  @override
  Widget build(BuildContext context) {
    String searchBoxText =
        productName ?? "Search for Products, Brands and more";
    Color searchBoxTextColor = productName == null ? Colors.grey : Colors.black;

    List<Widget> searchBarContent = [
      Icon(
        Icons.search,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        searchBoxText,
        style: TextStyle(
          color: searchBoxTextColor,
          fontSize: 15,
        ),
      ),
    ];
    if (productName != null) {
      searchBarContent = searchBarContent.reversed.toList();
    }
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(SearchScreen.routeName),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: productName == null
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          children: searchBarContent,
        ),
      ),
    );
  }
}
