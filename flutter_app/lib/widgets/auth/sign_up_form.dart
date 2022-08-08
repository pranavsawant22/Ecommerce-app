import 'package:e_comm_tata/data_fetching_api_calls/sign_up_api_call/send_OTP_api.dart';
import 'package:e_comm_tata/data_fetching_api_calls/sign_up_api_call/sign_up_details_holder.dart';
import 'package:e_comm_tata/screens/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_fetching_api_calls/sign_up_api_call/check_email_exist_api.dart';
import '../../utils/auth/constants.dart';
import '../../utils/size_config.dart';
import 'common_widgets/custom_surfix_icon.dart';
import 'common_widgets/default_button.dart';
import 'common_widgets/form_error.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? confirm_password;
  final List<String?> errors = [];
  SignUpDetailsHolder user = SignUpDetailsHolder();

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
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                bool emailExistCheck =
                    await CheckEmailExistAPI.checkEmailAlreadyExistAPICall(
                        email!);
                if (!emailExistCheck) {
                  bool sendOTPAPIstatus =
                      await SendOTPAPI.sendOTPAPICall(email!);
                  if (sendOTPAPIstatus == true) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('email_register', email!);
                    await prefs.setString('password_register', password!);
                    Navigator.pushReplacementNamed(
                        context, OtpScreen.routeName1);
                  } else {
                    addError(
                        error: 'Oops, Something Went Wrong, Please Try Again');
                  }
                } else {
                  addError(error: 'Email Already Exists, Please Sign In');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirm_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == confirm_password) {
          removeError(error: kMatchPassError);
        }
        confirm_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Password Cannot Be Empty";
        } else if ((password != value)) {
          return "Passwords Doesn't match";
        }
        return null;
      },
      decoration: const InputDecoration(
        focusedBorder: kInputBorderStyle,
        labelStyle: kInputLabelStyle,
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/images/icons/auth/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) {
        password = newValue;
        user.password = password;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Password Cannot Be Empty";
        } else if (value.length < 8) {
          return "Password Cannot Be Less Than 8 Characters";
        }
        return null;
      },
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/images/icons/auth/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) {email = newValue;
        user.email = email;},
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return "Email Cannot Be Empty";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return "Email Format Invalid";
        }
        return null;
      },
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/images/icons/auth/Mail.svg"),
      ),
    );
  }
}
