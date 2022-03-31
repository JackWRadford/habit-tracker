import 'package:flutter/material.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/ui/widgets/home_view/habit_card/habit_list_item.dart';
import 'package:provider/provider.dart';

/// Reorderable list of habits
class HabitsList extends StatefulWidget {
  final List<Habit> habits;
  const HabitsList({Key? key, required this.habits}) : super(key: key);

  @override
  State<HabitsList> createState() => _HabitsListState();
}

class _HabitsListState extends State<HabitsList> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      reverse: true,
      shrinkWrap: true,
      itemCount: widget.habits.length,
      itemBuilder: (context, index) {
        return ReorderableDelayedDragStartListener(
          key: Key('$index'),
          child: HabitListItem(habit: widget.habits[index]),
          index: index,
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final Habit item = widget.habits.removeAt(oldIndex);
          widget.habits.insert(newIndex, item);
        });
        // Update habits (new positions)
        Provider.of<HomeModel>(context, listen: false)
            .updateHabits(widget.habits);
      },
    );
  }
}
