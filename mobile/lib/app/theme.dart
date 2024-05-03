import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum UsedColors {
  black(value: Color.fromARGB(255, 10, 10, 10)),
  yellow(value: Color.fromARGB(255, 255, 214, 0)),
  white(value: Color.fromARGB(255, 255, 255, 255)),
  gray(value: Color.fromARGB(255, 38, 38, 38));

  const UsedColors({required this.value});

  final Color value;
}

final _buttonBorder = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(10)),
  borderSide: BorderSide(
    color: UsedColors.white.value,
  ),
);

final MaterialStateProperty<Color?> switchTrackColor =
    MaterialStateProperty.resolveWith<Color?>(
  (Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return UsedColors.yellow.value;
    }
    return null;
  },
);
final MaterialStateProperty<Color?> switchOverlayColor =
    MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
  if (states.contains(MaterialState.selected)) {
    return UsedColors.yellow.value.withOpacity(0.54);
  }
  if (states.contains(MaterialState.disabled)) {
    return Colors.grey.shade400;
  }
  return null;
});

final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: UsedColors.black.value,
    highlightColor: UsedColors.yellow.value,
    iconTheme: IconThemeData(
      color: UsedColors.white.value,
    ),
    textTheme: const TextTheme(),
    switchTheme: SwitchThemeData(
      trackColor: switchTrackColor,
      overlayColor: switchOverlayColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: _buttonBorder,
        focusedBorder: _buttonBorder.copyWith(
            borderSide: BorderSide(color: UsedColors.yellow.value)),
        focusedErrorBorder: _buttonBorder.copyWith(
            borderSide: BorderSide(color: UsedColors.yellow.value))),
    sliderTheme: SliderThemeData(
      activeTrackColor: UsedColors.yellow.value,
      secondaryActiveTrackColor: UsedColors.yellow.value.withOpacity(0.3),
      thumbColor: UsedColors.yellow.value,
    ));

final talkerScreenTheme =
    TalkerScreenTheme(backgroundColor: UsedColors.black.value);
