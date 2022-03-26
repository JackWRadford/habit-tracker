import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';

class SectionLabel extends StatelessWidget {
  final String labelText;

  const SectionLabel({Key? key, required this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        mediumPadding,
        mediumPadding,
        0,
        smallPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                labelText,
                style: textFootnote.copyWith(color: myGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
