import 'package:flutter/material.dart';

///spacing widgets helper
class UIHelper {
  //define spaces
  static const double spaceVerySmall = 4.0;
  static const double spaceSmall = 8.0;
  static const double spaceMedium = 16.0;
  static const double spaceLarge = 32.0;

  ///vertical very small
  static Widget verticalSpaceVerySmall() {
    return verticalSpace(spaceVerySmall);
  }

  ///vertical small
  static Widget verticalSpaceSmall() {
    return verticalSpace(spaceSmall);
  }

  ///vertical medium
  static Widget verticalSpaceMedium() {
    return verticalSpace(spaceMedium);
  }

  ///vertical large
  static Widget verticalSpaceLarge() {
    return verticalSpace(spaceLarge);
  }

  ///horizontal very small
  static Widget horizontalSpaceVerySmall() {
    return horizontalSpace(spaceVerySmall);
  }

  ///horizontal small
  static Widget horizontalSpaceSmall() {
    return horizontalSpace(spaceSmall);
  }

  ///horizontal medium
  static Widget horizontalSpaceMedium() {
    return horizontalSpace(spaceMedium);
  }

  ///horizontal large
  static Widget horizontalSpaceLarge() {
    return horizontalSpace(spaceLarge);
  }

  ///vertical sized box
  static Widget verticalSpace(double size) {
    return SizedBox(height: size);
  }

  ///horizontal sized bos
  static Widget horizontalSpace(double size) {
    return SizedBox(width: size);
  }
}
