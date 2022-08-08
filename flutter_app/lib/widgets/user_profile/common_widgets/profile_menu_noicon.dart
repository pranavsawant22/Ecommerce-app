import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class ProfileMenu extends StatelessWidget {
  final Color backgroundColor;
  const ProfileMenu({
    Key? key,
    required this.text,
    // required this.icon,
    this.press,
    required this.backgroundColor,
  }) : super(key: key);

  final String text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: backgroundColor,
        ),
        onPressed: press,
        child: Row(
          children: [
            // SvgPicture.asset(
            //   icon,
            //   color: Colors.white12,
            //   width: 22,
            // ),
            // SizedBox(width: 15),
            Expanded(
                child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            )),
            // Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
