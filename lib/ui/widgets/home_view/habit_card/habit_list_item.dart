import 'package:flutter/material.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/ui/helper/route_view_args.dart';
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Navigate to add/ edit habit view
        Navigator.pushNamed(
          context,
          '/habitView',
          arguments: HabitArgs(habit: widget.habit),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            mediumPadding, 0, mediumPadding, mediumPadding),
        child: SizedBox(
          height: 96,
          child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(smallRadius))),
            margin: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Percentage progress and day indicators
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    mediumPadding,
                    smallPadding,
                    smallPadding,
                    0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Last 30 days completed percentage
                      Text(
                        '${(widget.habit.last30 * 100).toInt()}%',
                        style: textCaption1,
                      ),
                      // Last week completed or not
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
                                habit: widget.habit,
                                habitDay: widget.habit.lastWeek[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Title
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: mediumPadding,
                            bottom: smallPadding,
                            right: mediumPadding),
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
                // Progress indicator
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(smallRadius),
                  ),
                  child: LinearProgressIndicator(
                    value: widget.habit.last30,
                    backgroundColor: widget.habit.color.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation(widget.habit.color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
