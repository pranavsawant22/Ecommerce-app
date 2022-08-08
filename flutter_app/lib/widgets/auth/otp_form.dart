import 'package:e_comm_tata/data_fetching_api_calls/sign_up_api_call/send_OTP_api.dart';
import 'package:e_comm_tata/data_fetching_api_calls/sign_up_api_call/validate_otp.dart';
import 'package:e_comm_tata/screens/auth/complete_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_fetching_api_calls/sign_up_api_call/sign_up_details_holder.dart';
import '../../screens/auth/change_password_screen.dart';
import '../../utils/auth/constants.dart';
import '../../utils/size_config.dart';
import 'common_widgets/default_button.dart';
import 'common_widgets/form_error.dart';

class OtpForm extends StatefulWidget {
  final int screen;
  OtpForm({
    Key? key,
    required this.screen,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  List<String> otp = List.generate(6, (index) => '');

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(50),
                child: TextFormField(
                  autofocus: true,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    otp[0] = value;
                    nextField(value, pin2FocusNode);
                    removeError(error: kOTPNullError);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kOTPNullError);
                      return "";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(52),
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    otp[1] = value;
                    nextField(value, pin3FocusNode);
                    removeError(error: kOTPNullError);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kOTPNullError);
                      return "";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(52),
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    otp[2] = value;
                    nextField(value, pin4FocusNode);
                    removeError(error: kOTPNullError);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kOTPNullError);
                      return "";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(52),
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      otp[3] = value;
                      nextField(value, pin5FocusNode);
                      removeError(error: kOTPNullError);
                      // Then you need to check is the code is correct or not
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kOTPNullError);
                      return "";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(52),
                child: TextFormField(
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    // Then you need to check is the code is correct or not
                    if (value.length == 1) {
                      otp[4] = value;
                      nextField(value, pin6FocusNode);
                      removeError(error: kOTPNullError);
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kOTPNullError);
                      return "";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(52),
                child: TextFormField(
                  focusNode: pin6FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      otp[5] = value;
                      pin6FocusNode!.unfocus();
                      removeError(error: kOTPNullError);
                      // Then you need to check is the code is correct or not
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      addError(error: kOTPNullError);
                      return "";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          FormError(errors: errors),
          SizedBox(
            height: SizeConfig.screenHeight * 0.05,
          ),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                final prefs = await SharedPreferences.getInstance();
                bool otpValid = await ValidateOTPAPI.validateOTPAPICall(
                    prefs.getString('email_register')!, otp.join());
                if (otpValid) {
                  if (widget.screen == 2) {
                    Navigator.pushNamed(
                        context, ChangePasswordScreen.routeName);
                  } else if (widget.screen == 1) {
                      Navigator.pushReplacementNamed(
                          context, CompleteProfileScreen.routeName);
                  }
                }
                else{
                  addError(error: "Invalid OTP");
                }
              }
            },
          )
        ],
      ),
    );
  }
}
