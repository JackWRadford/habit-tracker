import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/models/habit_day.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:provider/provider.dart';

/// Icon to show if habit has been completed for the given day
///
/// Can be pressed to toggle done or not
class HabitDayTick extends StatelessWidget {
  final Habit habit;
  final HabitDay habitDay;
  const HabitDayTick({
    Key? key,
    required this.habit,
    required this.habitDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        habitDay.isDone = !habitDay.isDone;
        // Update habit day
        Provider.of<HomeModel>(context, listen: false).updateHabitDay(habitDay);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: tinyPadding),
        child: SizedBox(
          width: 20,
          child: (habitDay.isDone)
              ? Icon(CupertinoIcons.checkmark_alt, size: 20, color: habit.color)
              : (_habitIncludesDay(habit, habitDay))
                  ? Icon(CupertinoIcons.circle_fill,
                      size: 12, color: habit.color.withOpacity(0.2))
                  : Icon(CupertinoIcons.circle_fill,
                      size: 12,
                      color: Provider.of<ThemeNotifier>(context).getBGColor()),
        ),
      ),
    );
  }
}

/// Check if [habit] is due on [habitDay]
bool _habitIncludesDay(Habit habit, HabitDay habitDay) {
  // Monday = 1, Tuesday = 2...
  int weekday = habitDay.date.weekday;
  return habit.requiredDays[weekday - 1];
}
