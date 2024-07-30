import 'package:flutter/material.dart';

const mobileBackgroundColor = Color.fromRGBO(0, 0, 0, 1);
const webBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
const mobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
final darksecondcolor = Colors.grey.shade700;

// Define color constants
const Color lightTextColor = Colors.black;
const Color darkTextColor = Colors.white;

// Function to get text color based on the theme
Color getTextColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? darkTextColor
      : lightTextColor;
}

// Similar functions can be created for other color types, e.g., background color
Color getBackgroundColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color.fromARGB(255, 23, 23, 23)
      : Colors.white;
}
