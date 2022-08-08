import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color? textColor;
  final Color? backgroundColor;
  const PillButton(
      {Key? key,
      required this.onPressed,
      required this.buttonText,
      this.textColor,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
    );
  }
}
