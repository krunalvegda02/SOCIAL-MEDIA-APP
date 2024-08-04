import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color borderColor;
  final Color textColor;
  final Color backGroundColor;
  final String text;
  const FollowButton(Null Function() param0, 
      {super.key,
      required this.borderColor,
      required this.function,
      required this.text,
      required this.textColor,
      required this.backGroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      //THIS PADDING IS FOR SOME SPACE BETWEEN BUTTON AND FOLLOW COUNTER
      padding: const EdgeInsets.only(top: 3),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backGroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          width: 237,
          height: 28,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
