import 'package:flutter/material.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/widgets/shared/section_element.dart';

/// Used for picking dates and times (durations) and displaying them/
class SectionTimeDatePicker extends StatelessWidget {
  final SettingsPos pos; // Top:0,middle:1,bottom:2
  final void Function() onTap;
  final String value;
  // Optional label for section (on the left)
  final String? label;

  const SectionTimeDatePicker({
    Key? key,
    required this.pos,
    required this.onTap,
    required this.value,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionElement(
      pos: pos,
      transparant: false,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(
            mediumPadding,
          ),
          child: (label != null)
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Label
                    Text(
                      label!,
                      style: textBody,
                    ),
                    // Value
                    Text(
                      value,
                      style: textBody,
                    ),
                  ],
                )
              : Center(
                  child: Text(
                    value,
                    style: textBody,
                  ),
                ),
        ),
      ),
      hasIndent: false,
    );
  }
}
