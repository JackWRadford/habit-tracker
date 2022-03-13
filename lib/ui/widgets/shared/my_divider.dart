import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';

class MyDivider extends StatelessWidget {
  final double indent;

  const MyDivider({Key? key, required this.indent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: indent,
      thickness: 0.2,
      color: myGrey,
      height: 0,
    );
  }
}
