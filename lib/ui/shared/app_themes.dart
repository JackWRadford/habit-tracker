import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';

///app themes
final darkTheme = ThemeData(
  canvasColor: darkBG,
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: darkBG,
  //remove splash from tab bar
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  dialogBackgroundColor: darkBG,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: mediumElevation,
    backgroundColor: darkCard,
    selectedItemColor: Colors.white,
    unselectedItemColor: myGrey,
  ),
  cardColor: darkCard,
  cardTheme: CardTheme(
    elevation: largeElevation,
    shadowColor: darkBG.withOpacity(0.4),
  ),
  dividerTheme: const DividerThemeData(
    color: darkBG,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: darkBG,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    elevation: 0,
  ),
  cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      dateTimePickerTextStyle: textBody.copyWith(color: Colors.white),
      pickerTextStyle: textBody.copyWith(color: Colors.white),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.white,
  ),
  chipTheme: ChipThemeData(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(smallRadius))),
    backgroundColor: darkBG,
    disabledColor: darkBG,
    selectedColor: darkBG,
    secondarySelectedColor: darkCard,
    padding: const EdgeInsets.all(tinyPadding),
    labelStyle: textSubhead.copyWith(color: myGrey),
    secondaryLabelStyle: textSubhead.copyWith(color: Colors.white),
    brightness: Brightness.light,
  ),
);

final lightTheme = ThemeData(
  canvasColor: lightBG,
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  scaffoldBackgroundColor: lightBG,
  //remove splash from tab bar
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  dialogBackgroundColor: lightBG,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: mediumElevation,
    backgroundColor: lightCard,
    selectedItemColor: Colors.black,
    unselectedItemColor: myGrey,
  ),
  cardColor: lightCard,
  cardTheme: CardTheme(
    elevation: largeElevation,
    shadowColor: lightBG.withOpacity(0.1),
  ),
  dividerTheme: const DividerThemeData(
    color: lightBG,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: lightBG,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    elevation: 0,
  ),
  cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      dateTimePickerTextStyle: textBody.copyWith(color: Colors.black),
      pickerTextStyle: textBody.copyWith(color: Colors.black),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black,
  ),
  chipTheme: ChipThemeData(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(smallRadius))),
    backgroundColor: lightBG,
    disabledColor: lightBG,
    selectedColor: lightBG,
    secondarySelectedColor: lightCard,
    padding: const EdgeInsets.all(tinyPadding),
    labelStyle: textSubhead.copyWith(color: myGrey),
    secondaryLabelStyle: textSubhead.copyWith(color: Colors.black),
    brightness: Brightness.light,
  ),
);
