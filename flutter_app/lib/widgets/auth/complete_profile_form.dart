import 'package:e_comm_tata/data_fetching_api_calls/sign_up_api_call/register_api.dart';
import 'package:e_comm_tata/screens/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/auth/constants.dart';
import '../../utils/size_config.dart';
import 'common_widgets/custom_surfix_icon.dart';
import 'common_widgets/default_button.dart';
import 'common_widgets/form_error.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  String registered = '';

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
          buildFirstNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLastNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          // buildAddressFormField(
          //     label: "Address",
          //     hint: "Enter your address",
          //     keyboard: TextInputType.streetAddress),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     SizedBox(
          //         width: getProportionateScreenWidth(160),
          //         child: buildAddressFormField(
          //             hint: "Landmark", keyboard: TextInputType.streetAddress)),
          //     SizedBox(
          //         width: getProportionateScreenWidth(160),
          //         child: buildAddressFormField(
          //             hint: "City", keyboard: TextInputType.text)),
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     SizedBox(
          //         width: getProportionateScreenWidth(160),
          //         child: buildAddressFormField(
          //             hint: "State", keyboard: TextInputType.text)),
          //     SizedBox(
          //         width: getProportionateScreenWidth(160),
          //         child: buildAddressFormField(
          //             hint: "Pincode", keyboard: TextInputType.number)),
          //   ],
          // ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if(registered != 'success') {
                  registered = await RegisterAPI.registerAPICall(
                      firstName!, lastName!, phoneNumber!);
                }
                if(registered == 'success'){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    SignInScreen.routeName,
                    ModalRoute.withName(SignInScreen.routeName),
                  );
                }
                else{
                  addError(error: registered);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildAddressFormField(
      {String? label, required String hint, required TextInputType keyboard}) {
    return TextFormField(
      keyboardType: keyboard,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        focusedBorder: kInputBorderStyle,
        labelStyle: kInputLabelStyle,
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: (label == "Address")
            ? const CustomSurffixIcon(
                svgIcon: "assets/images/icons/auth/Location point.svg")
            : null, // It will not show the location pin icon for any address fields other than the first one
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kInvalidPhoneError);
        } else if (phoneValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidPhoneError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kInvalidPhoneError);
          return "";
        } else if (!phoneValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidPhoneError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        focusedBorder: kInputBorderStyle,
        labelStyle: kInputLabelStyle,
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/images/icons/auth/Phone.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        focusedBorder: kInputBorderStyle,
        labelStyle: kInputLabelStyle,
        labelText: "Last Name",
        hintText: "Enter your last name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/images/icons/auth/User.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamefNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamefNullError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
          focusedBorder: kInputBorderStyle,
          labelStyle: kInputLabelStyle,
          labelText: "First Name",
          hintText: "Enter your first name",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon:
              CustomSurffixIcon(svgIcon: "assets/images/icons/auth/User.svg")),
    );
  }
}
