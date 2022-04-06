import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/core/providers/add_edit_habit_model.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/widgets/shared/section_element.dart';
import 'package:habit_tracker/ui/widgets/shared/section_label.dart';
import 'package:provider/provider.dart';

/// Days select section
class DaysSelect extends StatelessWidget {
  const DaysSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Current selected days
    List<bool> _selectedDays =
        Provider.of<AddEditHabitModel>(context).selectedDays;
    // Day label strings
    List<String> _daysStrings = [
      AppLocalizations.of(context)!.monday,
      AppLocalizations.of(context)!.tuesday,
      AppLocalizations.of(context)!.wednesday,
      AppLocalizations.of(context)!.thursday,
      AppLocalizations.of(context)!.friday,
      AppLocalizations.of(context)!.saturday,
      AppLocalizations.of(context)!.sunday,
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(labelText: AppLocalizations.of(context)!.repeatOn),
        Flexible(
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 7,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Provider.of<AddEditHabitModel>(context, listen: false)
                        .setSelectedDay(index);
                  },
                  child: SectionElement(
                    hasIndent: false,
                    pos: (index == 0)
                        ? SettingsPos.top
                        : (index == 6)
                            ? SettingsPos.bottom
                            : SettingsPos.middle,
                    child: Padding(
                      padding: const EdgeInsets.all(mediumPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(_daysStrings[index], style: textBody),
                          Icon(
                            CupertinoIcons.checkmark_alt,
                            color: (_selectedDays[index])
                                ? Provider.of<AddEditHabitModel>(context)
                                    .selectedColor
                                : Colors.transparent,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
