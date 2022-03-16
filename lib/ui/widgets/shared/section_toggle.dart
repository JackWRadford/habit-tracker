import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/widgets/shared/section_element.dart';

class SectionToggle extends StatelessWidget {
  final SettingsPos pos; //top:0,middle:1,bottom:2
  final String title;
  final void Function(bool value)? onChanged;
  final bool value;

  const SectionToggle({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.pos,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionElement(
      hasIndent: false,
      pos: pos,
      transparant: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          mediumPadding,
          smallPadding,
          smallPadding,
          smallPadding,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: textBody,
              ),
            ),
            CupertinoSwitch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
