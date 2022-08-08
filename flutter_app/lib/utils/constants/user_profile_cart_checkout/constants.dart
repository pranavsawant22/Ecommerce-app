import 'package:flutter/material.dart';

import '../../size_config.dart';

const kPrimaryColor = Colors.black; //Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.white,
  height: 1.5,
);

const kInputBorderStyle = UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.white),
);

const kInputLabelStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp phoneValidatorRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10}$)');
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kOTPNullError = "Please Enter your OTP";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamefNullError = "Please Enter your first name";
const String kNamelNullError = "Please Enter your last name";
const String kInvalidPhoneError = "Please Enter a Valid Phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}
