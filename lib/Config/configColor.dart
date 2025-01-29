
import 'package:flutter/material.dart';

class configColor{
  static String colorToRGBA(Color color){
    return '${color.red},${color.green},${color.blue},${color.alpha}';
  }

  static Color rgbaToColor(String input){
    List<String> parts = input.split(',');
    return Color.fromARGB(int.parse(parts[3]), int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
  }
}