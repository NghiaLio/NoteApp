import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background:const Color.fromARGB(255, 236, 230, 230),
      primary: Colors.white,
      surface: Colors.black,
      onSurface: Colors.grey.shade500,
      shadow: const Color.fromRGBO(60, 64, 67, 0.3)
    ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 236, 230, 230),

);

ThemeData darkMode = ThemeData(
  brightness:Brightness.dark,
      colorScheme: ColorScheme.dark(
            background: const Color.fromARGB(255,28, 28, 28,),
            primary: const Color.fromARGB(255,20, 20, 20,),
            surface: Colors.white,
            onSurface: Colors.grey.shade400,
            shadow: const Color.fromRGBO(228, 228, 232, 0.7843137254901961)
      ),
  scaffoldBackgroundColor:  const Color.fromARGB(255,28, 28, 28,)
);