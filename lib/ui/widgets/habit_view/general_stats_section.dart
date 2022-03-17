import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/analytics_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:provider/provider.dart';

class GeneralStatsSection extends StatelessWidget {
  final Habit habit;
  const GeneralStatsSection({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnalyticsModel _aModel =
        Provider.of<AnalyticsModel>(context, listen: false);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatSection(
          future: _aModel.getTimesDone(habit),
          label: AppLocalizations.of(context)!.timesDone,
          iconData: CupertinoIcons.check_mark,
          color: habit.color,
          isPercentage: false,
        ),
        UIHelper.horizontalSpaceSmall(),
        _StatSection(
          future: _aModel.getTimesMissed(habit),
          label: AppLocalizations.of(context)!.timesMissed,
          iconData: CupertinoIcons.xmark,
          color: habit.color,
          isPercentage: false,
        ),
      ],
    );
  }
}

/// For a stat in the general stats section
class _StatSection extends StatelessWidget {
  final Future<Object> future;
  final String label;
  final IconData iconData;
  final Color color;
  final bool isPercentage;
  const _StatSection(
      {Key? key,
      required this.future,
      required this.label,
      required this.iconData,
      required this.color,
      required this.isPercentage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: 0,
        future: future,
        builder: (context, snapshot) {
          return Expanded(
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(smallRadius))),
              child: Padding(
                padding: const EdgeInsets.all(smallPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(smallPadding),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(tinyRadius)),
                      ),
                      child: Icon(
                        iconData,
                        color: color,
                        size: 20,
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Value
                        Text(
                            (!isPercentage)
                                ? snapshot.data.toString()
                                : '${((snapshot.data as double) * 100).toInt()}%',
                            style: textBody),
                        // Label
                        Text(label,
                            style: textCaption1.copyWith(color: myGrey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
