import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/widgets/shared/my_alert_dialog.dart';
import 'package:habit_tracker/ui/widgets/shared/section_element.dart';
import 'package:provider/provider.dart';

class DeleteBtn extends StatelessWidget {
  final Habit habit;
  const DeleteBtn({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => MyAlertDialog(
              title: AppLocalizations.of(context)!.confirmTitle,
              content: AppLocalizations.of(context)!.confirmDesc,
              cancelActionText: AppLocalizations.of(context)!.cancel,
              defaultActionText: AppLocalizations.of(context)!.delete,
              isDestructive: true,
              defaultActionOnPressed: () {
                Provider.of<HomeModel>(context, listen: false)
                    .deleteHabit(habit.id!);
                // Pop three times
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ == 3;
                });
              }),
        );
      },
      child: SectionElement(
        color: CupertinoColors.destructiveRed.withOpacity(0.1),
        hasIndent: false,
        pos: SettingsPos.solo,
        child: Padding(
          padding: const EdgeInsets.all(mediumPadding),
          child: Center(
            child: Text(AppLocalizations.of(context)!.delete,
                style: textFootnote.copyWith(color: myRed)),
          ),
        ),
      ),
    );
  }
}
