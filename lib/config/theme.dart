import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle appTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    fontFamily: "Poppins",
    color: Colors.white,
    wordSpacing: 2,
  );
  static const TextStyle appTitleNoBold = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    // fontFamily: "Poppins",
    color: Colors.white,
    wordSpacing: 2,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,

    color: Color.fromARGB(255, 148, 169, 185),
  );

  static const TextStyle small = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: "Nunito",
    color: Colors.white,
  );
  static const TextStyle smallwithoutBold = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: "Poppins",
    color: Colors.white,
  );
}
