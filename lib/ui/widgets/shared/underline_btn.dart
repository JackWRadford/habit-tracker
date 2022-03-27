import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';

class UnderlineBtn extends StatelessWidget {
  final String text;
  final Function() onTap;

  const UnderlineBtn({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        text,
        style: textFootnote.copyWith(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
