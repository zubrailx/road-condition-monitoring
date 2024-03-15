import 'package:flutter/material.dart';

enum UsedColors {
  black(value: Color.fromARGB(255, 10, 10, 10)),
  yellow(value: Color.fromARGB(255, 255, 214, 0)),
  white(value: Color.fromARGB(255, 255, 255, 255));

  const UsedColors({required this.value});

  final Color value;
}

final darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: UsedColors.black.value,
  highlightColor: UsedColors.yellow.value,
  iconTheme: IconThemeData(
    color: UsedColors.white.value,
  ),
  textTheme: TextTheme(


  )
);
