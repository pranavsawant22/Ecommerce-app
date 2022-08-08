import 'package:e_comm_tata/utils/exception_handling/CustomException.dart';
import 'package:e_comm_tata/utils/exception_handling/user_not_log_in_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_fetching_api_calls/check_user_logged_in_api_call/check_user_logged_in.dart';
import '../../data_fetching_api_calls/pdp_data_fetch_api_call/pdp_add_to_cart_api.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/cart_checkout/checkout_screen.dart';

class FloatingButtonReuse extends StatelessWidget {
  String name;
  double leftPosition;
  double bottomPosition;
  double rightPosition;
  String heroTag;
  Map<String, dynamic> productData;
  FloatingButtonReuse(
      {required this.name,
      required this.productData,
      required this.bottomPosition,
      required this.leftPosition,
      required this.rightPosition,
      required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: leftPosition,
      bottom: bottomPosition,
      right: rightPosition,
      child: Container(
        width: MediaQuery.of(context).orientation == Orientation.landscape
            ? MediaQuery.of(context).size.width * 0.20
            : MediaQuery.of(context).size.width * 0.40,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          heroTag: heroTag,
          onPressed: () async {
            if (name == 'Buy Now') {
              bool isLoggedIn =
                  await CheckUserLoggedInAPI.checkUserLogInAPICall();
              if (isLoggedIn == false) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Not Logged In!'),
                      content: Text('Please Log in to Checkout'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Okay',
                              style: TextStyle(color: Colors.white70)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.of(context).pushNamed(CheckoutScreen.routeName,
                    arguments: {"productData": productData});
              }
            } else {
              final pdpAddToCartApiProvider =
                  Provider.of<PdpAddToCartApi>(context, listen: false);
              try {
                await pdpAddToCartApiProvider.addToCartAPICall(
                    productData["kind"] + ":" + productData['slug']['current'],
                    1);
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Success'),
                      content: Text('Item Added Successfully'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Okay',
                              style: TextStyle(color: Colors.white70)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } on CustomException catch (error) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Alert'),
                      content: Text(error.cause),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'Okay',
                            style: TextStyle(color: Colors.white70),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } on UserNotLogInException catch (error) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Alert'),
                      content: Text(error.cause),
                      actions: <Widget>[
                        TextButton(
                          child: const Text(
                            'Okay',
                            style: TextStyle(color: Colors.white70),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                SignInScreen.routeName,
                                ModalRoute.withName(SignInScreen.routeName));
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
          },
          child: Text(
            name,
            style: TextStyle(fontSize: 20),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
