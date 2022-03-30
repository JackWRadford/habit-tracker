import 'package:flutter/material.dart';

/// Model for data used to build a heat column
/// Each column is a week
class HeatColData {
  final int? label;
  final List<Color> colors;

  HeatColData({
    required this.label,
    required this.colors,
  });
}
