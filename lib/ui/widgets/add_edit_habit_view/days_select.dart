import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/providers/add_edit_habit_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:provider/provider.dart';

/// Days select section
class DaysSelect extends StatelessWidget {
  const DaysSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Current selected days
    List<bool> daysValues =
        Provider.of<AddEditHabitModel>(context).selectedDays;
    // Day label strings
    List<String> daysStrings = [
      AppLocalizations.of(context)!.monday,
      AppLocalizations.of(context)!.tuesday,
      AppLocalizations.of(context)!.wednesday,
      AppLocalizations.of(context)!.thursday,
      AppLocalizations.of(context)!.friday,
      AppLocalizations.of(context)!.saturday,
      AppLocalizations.of(context)!.sunday,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.repeatOn, style: textFootnote),
              UIHelper.verticalSpaceVerySmall(),
              Text(AppLocalizations.of(context)!.cannotBeChanged,
                  style: textCaption2.copyWith(color: myRed)),
            ],
          ),
        ),
        UIHelper.verticalSpaceSmall(),
        Wrap(
          spacing: smallPadding,
          children: List<Widget>.generate(
            7,
            (int index) {
              return ChoiceChip(
                padding: const EdgeInsets.all(smallPadding),
                label: Text(daysStrings[index], style: textBody),
                selected: daysValues[index],
                onSelected: (bool selected) {
                  Provider.of<AddEditHabitModel>(context, listen: false)
                      .setSelectedDay(index, selected);
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
