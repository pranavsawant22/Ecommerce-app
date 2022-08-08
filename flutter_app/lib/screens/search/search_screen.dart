import 'package:e_comm_tata/utils/size_config.dart';

import '../../data_fetching_api_calls/search/search_api.dart';
import '../../screens/product_list/product_list_page.dart';
import '../../widgets/search/categories.dart';
import 'package:flutter/material.dart';

// Search screen
// Pushed on top of previous screen
// Popped out of stack when back arrow is pressed

class SearchScreen extends StatefulWidget {
  static String routeName = "/search";
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Controller for query TextField
  final _queryController = TextEditingController();

  AppBar buildAppBar() {
    return AppBar(
      actions: [
        // Button to clear the search box
        IconButton(
          onPressed: () {
            String oldText = _queryController.text;
            if (mounted && oldText != "") {
              setState(() {
                _queryController.text = "";
              });
            }
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
      centerTitle: false,
      title: TextField(
        onChanged: (value) {
          if (mounted) {
            setState(() {});
          }
        },
        onSubmitted: (val) {
          // Go to PLP only if query is non-empty
          if (val != '') {
            Navigator.of(context).pushReplacementNamed(
              ProductsListPage.routeName,
              arguments: {'type': 'search', 'query': val},
            );
          }
        },
        onEditingComplete: () {},
        style: const TextStyle(
          fontSize: 15,
        ),
        textInputAction: TextInputAction.search,
        autofocus: true,
        controller: _queryController,
        decoration: const InputDecoration(
          hintText: "Search for Products, Brands and more",
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildSearchResults() {
    return FutureBuilder(
      future: SearchAPI.fetchSearchResults(_queryController.text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white70,
            ),
          );
        } else {
          Iterable<SearchResult> searchResults =
              snapshot.data as Iterable<SearchResult>;
          if (searchResults.isEmpty) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.white,
                    size: 60,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  const Text(
                    "Sorry, no matches found",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              SearchResult res = searchResults.elementAt(index);
              String skuName = res.skuName;
              String category = res.category;
              String imageURL = res.imageURL;
              return Column(
                children: [
                  Material(
                    elevation: 6,
                    color: Theme.of(context).colorScheme.primary,
                    child: ListTile(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          ProductsListPage.routeName,
                          arguments: {'type': 'search', 'query': skuName},
                        );
                      },
                      leading: Image.network(imageURL),
                      title: Text(skuName),
                      subtitle: Text(category),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _queryController.text = skuName;
                          });
                        },
                        icon: const Icon(Icons.north_west),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          color: Theme.of(context).colorScheme.secondary,
          child: _queryController.text == ''
              ? const Categories()
              : buildSearchResults(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _queryController.dispose();
    super.dispose();
  }
}
