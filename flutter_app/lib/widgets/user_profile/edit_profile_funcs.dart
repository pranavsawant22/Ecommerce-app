import 'package:e_comm_tata/data_fetching_api_calls/user_profile_api_call/add_address_api.dart';
import 'package:e_comm_tata/data_fetching_api_calls/user_profile_api_call/delete_address_api.dart';
import 'package:e_comm_tata/data_fetching_api_calls/user_profile_api_call/get_address_api.dart';
import 'package:e_comm_tata/data_fetching_api_calls/user_profile_api_call/get_user_api.dart';
import 'package:e_comm_tata/data_fetching_api_calls/user_profile_api_call/update_address_api.dart';
import 'package:e_comm_tata/data_fetching_api_calls/user_profile_api_call/update_profile.dart';
import 'package:e_comm_tata/screens/landing_page/landing_page.dart';
import 'package:e_comm_tata/screens/user_profile/profile_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/auth/constants.dart';
import '../../utils/size_config.dart';
// import 'package:e_comm_tata/components/custom_surfix_icon.dart';
// import 'package:e_comm_tata/components/default_button.dart';
// import 'package:e_comm_tata/components/form_error.dart';

import 'common_widgets/form_error.dart';
import 'common_widgets/profile_menu_noicon.dart';
// import '../../otp/otp_screen.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyUpdateAddress = GlobalKey<FormState>();
  final _formKeyAddress = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? address;
  Future? getUserAPICall;
  Future? getAddressAPICall;
  List<TextEditingController> controller =
      List.generate(5, (index) => TextEditingController());
  var addresses;

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    super.initState();
    getUserAPICall = GetUserAPI.getUserAPICall();
    getAddressAPICall = GetAddressAPI.getAddressAPICall();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FutureBuilder(
          future: getUserAPICall,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              var error = snapshot.error;
              return ListTile(title: Text(error.toString()));
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildFirstNameFormField(snapshot.data["firstName"]),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  buildLastNameFormField(snapshot.data["lastName"]),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  // buildEmailFormField(),
                  // SizedBox(height: getProportionateScreenHeight(30)),
                  buildPhoneNumberFormField(snapshot.data["phone"]),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  FutureBuilder(
                      future: getAddressAPICall,
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          var error = snapshot.error;
                          return ListTile(title: Text(error.toString()));
                        } else {
                          addresses = snapshot.data;
                          return ExpansionTile(
                            title: Text("Edit Address",
                                style: TextStyle(color: Colors.white)),
                            tilePadding: EdgeInsets.symmetric(horizontal: 4),
                            children: [
                              Form(
                                key:_formKeyUpdateAddress,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return ExpansionTile(
                                      title: Text(snapshot.data[index]["name"],
                                          style: TextStyle(
                                              color: Colors
                                                  .white)), // add variable addresses from api call,
                                      trailing: MaterialButton(
                                        onPressed: () async {
                                          String response = await DeleteAddressAPI
                                              .deleteAddressAPICall(
                                                  snapshot.data[index]["_id"]);
                                          if (response != 'success') {
                                            addError(error: response);
                                          } else {
                                            setState(() {
                                              getAddressAPICall = GetAddressAPI
                                                  .getAddressAPICall();
                                            });
                                          }
                                        },
                                        child: Icon(Icons.delete),
                                      ),
                                      children: [
                                        ListTile(
                                          title: Column(
                                            children: [
                                              buildAddressFormField(
                                                  label: "Address",
                                                  hint: "Enter your address",
                                                  index: index,
                                                  output: "buildingInfo",
                                                  keyboard: TextInputType
                                                      .streetAddress,
                                                  initialValue:
                                                      snapshot.data[index]
                                                          ["buildingInfo"]),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          getProportionateScreenWidth(
                                                              130),
                                                      child: buildAddressFormField(
                                                          hint: "Landmark",
                                                          keyboard: TextInputType
                                                              .streetAddress,
                                                          index: index,
                                                          output: "landmark",
                                                          initialValue: snapshot
                                                                  .data[index]
                                                              ["landmark"])),
                                                  SizedBox(
                                                      width:
                                                          getProportionateScreenWidth(
                                                              130),
                                                      child: buildAddressFormField(
                                                          hint: "City",
                                                          keyboard:
                                                              TextInputType
                                                                  .text,
                                                          index: index,
                                                          output: "city",
                                                          initialValue: snapshot
                                                                  .data[index]
                                                              ["city"])),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          getProportionateScreenWidth(
                                                              130),
                                                      child: buildAddressFormField(
                                                          hint: "State",
                                                          keyboard:
                                                              TextInputType
                                                                  .text,
                                                          index: index,
                                                          output: "state",
                                                          initialValue: snapshot
                                                                  .data[index]
                                                              ["state"])),
                                                  SizedBox(
                                                      width:
                                                          getProportionateScreenWidth(
                                                              130),
                                                      child: buildAddressFormField(
                                                          hint: "Pincode",
                                                          keyboard:
                                                              TextInputType
                                                                  .number,
                                                          index: index,
                                                          output: "pincode",
                                                          initialValue: snapshot
                                                                  .data[index]
                                                              ["pincode"])),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              ExpansionTile(
                                title: const Text(
                                  "Add new address",
                                  style: TextStyle(color: Colors.white),
                                ),
                                children: [
                                  ListTile(
                                    title: Form(
                                      key: _formKeyAddress,
                                      child: Column(
                                        children: [
                                          buildAddressFormField(
                                              controller: controller[0],
                                              label: "Address",
                                              hint: "Enter your address",
                                              keyboard:
                                                  TextInputType.streetAddress),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          130),
                                                  child: buildAddressFormField(
                                                      controller: controller[1],
                                                      hint: "Landmark",
                                                      keyboard: TextInputType
                                                          .streetAddress)),
                                              SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          130),
                                                  child: buildAddressFormField(
                                                      controller: controller[2],
                                                      hint: "City",
                                                      keyboard:
                                                          TextInputType.text)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          130),
                                                  child: buildAddressFormField(
                                                      controller: controller[3],
                                                      hint: "State",
                                                      keyboard:
                                                          TextInputType.text)),
                                              SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          130),
                                                  child: buildAddressFormField(
                                                      controller: controller[4],
                                                      hint: "Pincode",
                                                      keyboard: TextInputType
                                                          .number)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          for (var x in controller) {
                                            x.clear();
                                          }
                                        },
                                        child: Text("Clear"),
                                      ),
                                      MaterialButton(
                                        onPressed: () async {
                                          if (_formKeyAddress.currentState!
                                              .validate()) {
                                            String name = controller[0]
                                                .text
                                                .split(" ")[0];
                                            var response = await AddAddressAPI
                                                .addAddressAPICall(
                                                    name,
                                                    controller[0].text,
                                                    controller[3].text,
                                                    controller[2].text,
                                                    controller[1].text,
                                                    controller[4].text);
                                            if (response != 'success') {
                                              addError(error: response);
                                            } else {
                                              setState(() {
                                                getAddressAPICall =
                                                    GetAddressAPI
                                                        .getAddressAPICall();
                                                for (var x in controller) {
                                                  x.clear();
                                                }
                                              });
                                            }
                                          }
                                        },
                                        child: Text("Save"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      }),

                  // buildAddressFormField(label: "Address", hint: "Enter your address",keyboard: TextInputType.streetAddress),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     SizedBox(
                  //         width: getProportionateScreenWidth(160),
                  //         child: buildAddressFormField(hint: "Landmark",keyboard: TextInputType.streetAddress)),
                  //     SizedBox(
                  //         width: getProportionateScreenWidth(160),
                  //         child: buildAddressFormField(hint: "City",keyboard: TextInputType.text)),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     SizedBox(
                  //         width: getProportionateScreenWidth(160),
                  //         child: buildAddressFormField(hint: "State",keyboard: TextInputType.text)),
                  //     SizedBox(
                  //         width: getProportionateScreenWidth(160),
                  //         child: buildAddressFormField(hint: "Pincode",keyboard: TextInputType.number)),
                  //   ],
                  // ),

                  FormError(errors: errors),
                  ProfileMenu(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    text: "Save Profile",
                    press: () async {
                      bool next=true;
                      if(_formKeyUpdateAddress.currentState!=null){
                        if(_formKeyUpdateAddress.currentState!.validate()) {
                          _formKeyUpdateAddress.currentState!.save();
                          for(int i =0;i<addresses.length;i++){
                            String name = addresses[i]["buildingInfo"].split(" ")[0];
                            var response =
                            await UpdateAddressAPI.updateAddressAPICall(name, addresses[i]["buildingInfo"], addresses[i]["state"], addresses[i]["city"], addresses[i]["landmark"], addresses[i]["pincode"], addresses[i]["_id"]);
                            if (response != 'success') {
                              addError(error: response);
                              next = false;
                            }
                          }
                        }
                      }
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String response =
                            await UpdateProfileAPI.updateProfileAPICall(
                                firstName!, lastName!, phoneNumber!);
                        if (response != 'success') {
                          addError(error: response);
                        } else if(next=true){
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                ProfileScreen.routeName,
                                ModalRoute.withName(LandingPage.routeName));
                        }
                        // update user profile api to be used
                      }
                    },
                  ),
                ],
              );
            }
          }),
    );
  }

  // TextFormField buildAddressFormField() {
  //   return TextFormField(
  //     initialValue: "Shatipur",
  //     onSaved: (newValue) => address = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kAddressNullError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         addError(error: kAddressNullError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: const InputDecoration(
  //       labelText: "Edit Address",
  //       hintText: "Enter your address",
  //       // If  you are using latest version of flutter then lable text and hint text shown like this
  //       // if you r using flutter less then 1.20.* then maybe this is not working properly
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       // suffixIcon:
  //       // CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
  //     ),
  //   );
  // }

  // TextFormField buildAddressFormField(
  //     {String? label, required String hint,required TextInputType keyboard}) {
  //   return TextFormField(
  //     keyboardType: keyboard,
  //     onSaved: (newValue) => address = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kAddressNullError);
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         addError(error: kAddressNullError);
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: label,
  //       hintText: hint,
  //       floatingLabelBehavior: FloatingLabelBehavior.always
  //       // suffixIcon:
  //       // (label == "Address")?const CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"):null,// It will not show the location pin icon for any address fields other than the first one
  //     ),
  //   );
  // }

  TextFormField buildPhoneNumberFormField(String phone) {
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
      initialValue: phone,
      decoration: const InputDecoration(
        focusedBorder: kInputBorderStyle,
        labelStyle: kInputLabelStyle,
        labelText: "Edit Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildFirstNameFormField(String fName) {
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
      initialValue: fName,
      decoration: const InputDecoration(
        focusedBorder: kInputBorderStyle,
        labelStyle: kInputLabelStyle,
        labelText: "Edit First Name",
        hintText: "Enter your first name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildLastNameFormField(String lName) {
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
      initialValue: lName,
      // controller:  TextEditingController()..text = 'Saha',
      // onSaved: (newValue) => lastName = newValue,
      decoration: const InputDecoration(
        focusedBorder: kInputBorderStyle,
        labelStyle: kInputLabelStyle,
        labelText: "Edit Last Name",
        hintText: "Enter your last name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildAddressFormField(
      {String? label,
      required String hint,
      required TextInputType keyboard,
      TextEditingController? controller,
        String? output,
        int? index,
      String? initialValue}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      initialValue: initialValue,
      onSaved: (newValue) => addresses[index][output] = newValue,
      onChanged: (value) {
        removeError(error: 'Please fill all the details');
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: 'Please fill all the details');
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
        // suffixIcon: (label == "Address")
        //     ? const CustomSurffixIcon(
        //     svgIcon: "assets/icons/Location point.svg")
        //     : null, // It will not show the location pin icon for any address fields other than the first one
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      initialValue: "defaultemail.com",
      onSaved: (newValue) => email = newValue,
      decoration: const InputDecoration(
        labelText: "Edit Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );

    // TextFormField buildFirstNameFormField() {
    //   return TextFormField(
    //     onSaved: (newValue) => firstName = newValue,
    //     onChanged: (value) {
    //       if (value.isNotEmpty) {
    //         removeError(error: kFNameNullError);
    //       }
    //       return null;
    //     },
    //     validator: (value) {
    //       if (value!.isEmpty) {
    //         addError(error: kFNameNullError);
    //         return "";
    //       }
    //       return null;
    //     },
    //     decoration: const InputDecoration(
    //       labelText: "Edit Name",
    //       hintText: "Enter your name",
    //       // If  you are using latest version of flutter then lable text and hint text shown like this
    //       // if you r using flutter less then 1.20.* then maybe this is not working properly
    //       floatingLabelBehavior: FloatingLabelBehavior.always,
    //       // suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
    //     ),
    //   );
    // }
  }
}
