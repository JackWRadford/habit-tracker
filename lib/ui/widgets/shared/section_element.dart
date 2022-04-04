import 'package:flutter/material.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/widgets/shared/my_divider.dart';

/// Extracts position styling of settings elements for reuse
class SectionElement extends StatelessWidget {
  final SettingsPos pos; // top:0,middle:1,bottom:2
  final Widget child;
  final bool hasIndent;
  final bool transparant; // trasparant for textInputs ()

  const SectionElement({
    Key? key,
    required this.pos,
    required this.child,
    required this.hasIndent,
    required this.transparant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      color: (transparant) ? Colors.transparent : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: ((pos == SettingsPos.solo) || (pos == SettingsPos.top))
              ? const Radius.circular(mediumRadius)
              : const Radius.circular(0),
          topRight: ((pos == SettingsPos.solo) || (pos == SettingsPos.top))
              ? const Radius.circular(mediumRadius)
              : const Radius.circular(0),
          bottomLeft: ((pos == SettingsPos.solo) || (pos == SettingsPos.bottom))
              ? const Radius.circular(mediumRadius)
              : const Radius.circular(0),
          bottomRight:
              ((pos == SettingsPos.solo) || (pos == SettingsPos.bottom))
                  ? const Radius.circular(mediumRadius)
                  : const Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          child,
          ((pos == SettingsPos.top) || (pos == SettingsPos.middle))
              ? MyDivider(indent: (hasIndent) ? settingsIndent : 0)
              : Container(),
        ],
      ),
    );
  }
}
