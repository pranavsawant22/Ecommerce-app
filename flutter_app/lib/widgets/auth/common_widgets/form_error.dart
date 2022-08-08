import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/size_config.dart';

// Widget helps display all the various validation errors from text fields to the user
class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String?> errors;
  // List of Errors to display and update
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index]!)),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/images/icons/auth/Error.svg",
          height: getProportionateScreenWidth(14),
          width: getProportionateScreenWidth(14),
        ),
        SizedBox(
          width: getProportionateScreenWidth(10),
        ),
        Text(error),
      ],
    );
  }
}
