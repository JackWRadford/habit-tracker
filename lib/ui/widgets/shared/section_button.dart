import 'package:flutter/material.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:habit_tracker/ui/widgets/shared/section_element.dart';

class SectionButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonLabel;
  final Color? labelColor;
  final Icon icon;
  final bool hasArrow;
  final SettingsPos pos; //top:0,middle:1,bottom:2

  const SectionButton({
    Key? key,
    required this.onPressed,
    required this.buttonLabel,
    this.labelColor,
    required this.icon,
    required this.hasArrow,
    required this.pos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionElement(
      hasIndent: true,
      pos: pos,
      transparant: false,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(mediumPadding),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  icon,
                  UIHelper.horizontalSpaceMedium(),
                  //label
                  Text(
                    buttonLabel,
                    style: textBody.copyWith(color: labelColor),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              (hasArrow)
                  ? const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: myGrey,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
