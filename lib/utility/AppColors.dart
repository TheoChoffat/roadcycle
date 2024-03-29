// ignore_for_file: file_names

import 'package:flutter/material.dart';

// usage: Container(color: AppColors.main.orange)
class AppColors {
  static _Main main = _Main();
  static _Scaffold scaffold = _Scaffold();
  static _Text text = _Text();
}

class _Main {
  Color orange = Color.fromRGBO(239, 79, 25, 1);
  Color white = const Color(0xfffbf8f7);
}

class _Scaffold {
  Color background = Colors.black;
}

class _Text {
  Color heading = Colors.white;
  Color subheading = Colors.white38;
}
