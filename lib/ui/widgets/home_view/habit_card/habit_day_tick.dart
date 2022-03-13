import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/core/models/habit_day.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:provider/provider.dart';

/// Icon to show if habit has been completed for the given day
///
/// Can be pressed to toggle done or not
class HabitDayTick extends StatelessWidget {
  final HabitDay habitDay;
  const HabitDayTick({Key? key, required this.habitDay}) : super(key: key);

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
              ? const Icon(CupertinoIcons.check_mark, size: 18)
              : const Icon(CupertinoIcons.circle, size: 12, color: myGrey),
        ),
      ),
    );
  }
}
