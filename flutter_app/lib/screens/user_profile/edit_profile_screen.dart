import 'package:flutter/material.dart';
//import 'package:shop_app/components/coustom_bottom_nav_bar.dart';

import '../../utils/size_config.dart';
import '../../widgets/user_profile/edit_profile_funcs.dart';

class EditProfileScreen extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(children: [
            // ProfilePic(),
            SizedBox(height: 0),
            CompleteProfileForm(),
          ]),
        ),
      ),
    );
  }
}
