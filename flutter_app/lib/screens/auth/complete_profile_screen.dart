import 'package:flutter/material.dart';

import '../../utils/auth/constants.dart';
import '../../utils/size_config.dart';
import '../../widgets/auth/complete_profile_form.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: const Text('Sign Up'),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    Text(
                      "Complete Profile",
                      style: kHeadingStyle,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    const Text(
                      "Complete your details",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.06),
                    CompleteProfileForm(),
                    SizedBox(height: getProportionateScreenHeight(30)),
                    Text(
                      "By continuing your confirm that you agree \nwith our Term and Condition",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
