import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_fetching_api_calls/sign_up_api_call/send_OTP_api.dart';
import '../../data_fetching_api_calls/sign_up_api_call/sign_up_details_holder.dart';
import '../../utils/auth/constants.dart';
import '../../utils/size_config.dart';
import '../../widgets/auth/otp_form.dart';

class OtpScreen extends StatelessWidget {
  static String routeName1 = "/otp1";
  static String routeName2 = "/otp2";
  final int screen;
  OtpScreen({required this.screen});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); //Getting screen size to initialize object
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("OTP Verification"),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  Text(
                    "OTP Verification",
                    style: kHeadingStyle,
                  ),
                  const Text("We sent your code to your email"),
                  buildTimer(),
                  OtpForm(
                    screen: screen,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.1),
                  GestureDetector(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      bool sendOTPAPIstatus =
                          await SendOTPAPI.sendOTPAPICall(prefs.getString('email')!);
                      if(sendOTPAPIstatus){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                            content: Text("OTP sent"),));
                      }
                    },
                    child: const Text(
                      "Resend OTP Code",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // OTP timer
  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("This code will expired in "),
        TweenAnimationBuilder(
          tween: Tween(begin: 30.0, end: 0.0),
          duration: const Duration(seconds: 30),
          builder: (_, dynamic value, child) => Text(
            "00:${value.toInt()}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
