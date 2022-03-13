import 'package:flutter/material.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/widgets/home_view/habit_card/habit_day_tick.dart';

/// Displays the habit title, last 7 days, percentage progress
class HabitListItem extends StatefulWidget {
  final Habit habit;
  const HabitListItem({Key? key, required this.habit}) : super(key: key);

  @override
  State<HabitListItem> createState() => _HabitListItemState();
}

class _HabitListItemState extends State<HabitListItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(smallRadius))),
        margin: const EdgeInsets.fromLTRB(
            mediumPadding, 0, mediumPadding, mediumPadding),
        child: Padding(
          padding: const EdgeInsets.all(smallPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Percentage progress and day indicators
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return HabitDayTick(
                            habitDay: widget.habit.lastWeek[index]);
                      },
                    ),
                  ),
                ],
              ),
              // Title
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: smallPadding, bottom: smallPadding),
                      child: Text(
                        widget.habit.title,
                        style: textBody,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
