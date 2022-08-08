// ignore_for_file: prefer_const_constructors

import 'package:e_comm_tata/data_fetching_api_calls/order_history_api_call/get_all_orders_api.dart';
import 'package:e_comm_tata/data_fetching_api_calls/user_profile_api_call/get_user_api.dart';
import 'package:e_comm_tata/data_fetching_api_calls/user_profile_api_call/user_details_holder.dart';
import 'package:e_comm_tata/screens/landing_page/landing_page.dart';
import 'package:e_comm_tata/screens/order_history/order_history_page.dart';
import 'package:e_comm_tata/utils/bottom_navbar/bottom_navbar_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_fetching_api_calls/user_profile_api_call/get_address_api.dart';
import '../../utils/bottom_navbar/page_index.dart';
import '../../utils/size_config.dart';
import '../../widgets/user_profile/common_widgets/dropdown.dart';
import '../../widgets/user_profile/common_widgets/profile_menu_noicon.dart';
import '../cart_checkout/cart_screen.dart';
import '../wishlist/wish_list.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    final getAllOrderAPIProvider =
        Provider.of<GetAllOrderAPI>(context, listen: false);

    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 0),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder(
                  future: GetUserAPI.getUserAPICall(),
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        "Hi, ${snapshot.data["firstName"]}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      );
                    } else {
                      return Text(
                        "Hi, User",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      );
                    }
                  }),
            ),
            Row(children: <Widget>[
              Expanded(
                child: ProfileMenu(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  text: "Orders",
                  // icon: "assets/icons/Bell.svg",
                  press: () async {
                    Navigator.pushNamed(context, OrderHistory.routeName);
                  },
                ),
              ),
              Expanded(
                child: ProfileMenu(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  text: "Cart",
                  // icon: "assets/icons/Bell.svg",
                  press: () {
                    Navigator.pushReplacementNamed(
                        context, CartScreen.routeName);
                  },
                ),
              )
            ]),
            Row(children: <Widget>[
              Expanded(
                child: ProfileMenu(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    text: "Reset Password",
                    // icon: "assets/icons/Bell.svg",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePasswordScreen()));
                    }),
              ),
              Expanded(
                child: ProfileMenu(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  text: "Wishlist",
                  press: () {
                    Navigator.pushReplacementNamed(context, Wishlist.routeName);
                  },
                ),
              )
            ]),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    // height: getProportionateScreenHeight(20),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FutureBuilder(
                          future: GetUserAPI.getUserAPICall(),
                          builder: (context, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              var error = snapshot.error;
                              return SideMenuExpanded(
                                  icon: Icon(Icons.error),
                                  s1: error.toString());
                            } else if (snapshot.hasData) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SideMenuExpanded(
                                      icon: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      s1: snapshot.data["firstName"] +
                                          " " +
                                          snapshot.data["lastName"]),
                                  SizedBox(height: 2),
                                  SideMenuExpanded(
                                      icon: Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      s1: snapshot.data["email"]),
                                  SizedBox(height: 2),
                                  SideMenuExpanded(
                                      icon: Icon(
                                        Icons.phone,
                                        color: Colors.white,
                                      ),
                                      s1: snapshot.data["phone"]),
                                  // Text('Phone no.:', textAlign: TextAlign.left, style: TextStyle(fontSize: 20)),
                                  SizedBox(height: 2),
                                  FutureBuilder(
                                      future: GetAddressAPI.getAddressAPICall(),
                                      builder: (context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          var error = snapshot.error;
                                          return SideMenuExpanded(
                                              icon: Icon(Icons.error),
                                              s1: error.toString());
                                        } else if (snapshot.hasData) {
                                          return SideMenuExpandedOptions(
                                            icon: Icon(
                                              Icons.pin_drop,
                                              color: Colors.white,
                                            ),
                                            s1: "Address",
                                            options:
                                                assembleAddress(snapshot.data),
                                          );
                                        } else {
                                          return SideMenuExpanded(
                                            icon: Icon(Icons.error),
                                            s1: "Something went wrong please try again",
                                          );
                                        }
                                      }),
                                  // ExpansionTile(title: ListTile(title: Text('Address',textAlign: TextAlign.left, style: TextStyle(fontSize: 20))),
                                  // Text('Address:', textAlign: TextAlign.left, style: TextStyle(fontSize: 20)),
                                  // SizedBox(height: getProportionateScreenHeight(190)),// change height for navbar config
                                  // )
                                ],
                              );
                            } else {
                              return SideMenuExpanded(
                                icon: Icon(Icons.error),
                                s1: "Something went wrong please try again",
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
            ProfileMenu(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              text: "Edit Profile",
              // icon: "assets/icons/Question mark.svg",
              press: () async {
                final prefs = await SharedPreferences.getInstance();
                if ((await GetUserAPI.getUserAPICall()).runtimeType != String) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen()));
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          BottomNavbarUtil(index: pageIndex["user_profile"] as int),
    );
  }

  List<String> assembleAddress(List<dynamic> addressJson) {
    List<String> addresses = [];
    for (var i in addressJson) {
      String address = i["buildingInfo"] +
          " " +
          i["state"] +
          " " +
          i["city"] +
          " " +
          i["pincode"];
      addresses.add(address);
    }
    return addresses;
  }
}
