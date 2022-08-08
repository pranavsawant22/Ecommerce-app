// import 'dart:math';

import 'package:e_comm_tata/data_fetching_api_calls/check_user_logged_in_api_call/check_user_logged_in.dart';
import 'package:e_comm_tata/data_fetching_api_calls/sign_up_api_call/logout_api.dart';
import 'package:e_comm_tata/screens/auth/sign_in_screen.dart';
import 'package:e_comm_tata/screens/landing_page/landing_page.dart';
import 'package:e_comm_tata/widgets/landing_page/expansion_tile_widget.dart';
import 'package:e_comm_tata/widgets/landing_page/tile_widget_content.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

//This is side bar widget for landing page
class _SideBarState extends State<SideBar> {
  void redirect(String name) {
    Navigator.of(context)
        .pushNamed("/TestPage", arguments: {"PageContent": name});
  }

  //function to see if user is already logged in
  Future<bool> _checkUserLogIn() async {
    var checkUser = await CheckUserLoggedInAPI.checkUserLogInAPICall();
    return checkUser;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            Stack(children: [
              UserAccountsDrawerHeader(
                accountName: const Text('Name'),
                accountEmail: const Text('example@gmail.com'),
                currentAccountPicture: const CircleAvatar(
                  child: ClipOval(
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'assets/images/icons/sidebar/side_bar_background.jpg')),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.45,
                top: 80,
                child: FutureBuilder(
                    future: _checkUserLogIn(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white70,
                          ),
                        );
                      } else {
                        if (snapshot.data) {
                          return TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary),
                              onPressed: () async {
                                //logout api call
                                await LogOutAPI.logOutAPICall();
                                Navigator.of(context).pushReplacementNamed(
                                    LandingPage.routeName);
                              },
                              child: const Text('LogOut',
                                  style: TextStyle(color: Colors.white)));
                        }
                        return TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(SignInScreen.routeName);
                            }, //logout
                            child: const Text('SignIn/SignUp',
                                style: TextStyle(color: Colors.white)));
                      }
                    }),
              ),
            ]),
            SideMenuExpandedOptions(
              icon: const Icon(
                Icons.phone_android_rounded,
                color: Colors.white,
              ),
              s1: "Assistance",
              options: TileWidgetContent.contentList([
                "Terms & Services",
                "Exchange & Return Policy",
                "Privacy Policy"
              ], redirect),
            ),
            SideMenuExpandedOptions(
              icon: const Icon(
                Icons.phone,
                color: Colors.white,
              ),
              s1: "Contact us",
              options: TileWidgetContent.contentList(
                  ["Phone Number", "Email Id"], redirect),
            ),
            SideMenuExpandedOptions(
              icon: const Icon(
                Icons.phone_android_rounded,
                color: Colors.white,
              ),
              s1: "SocialNetworks",
              options: TileWidgetContent.contentList(
                  ["Instagram", "Facebook", "Twitter"], redirect),
            ),
          ]),
    );
  }
}
