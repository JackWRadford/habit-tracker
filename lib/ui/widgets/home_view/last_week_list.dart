import 'package:flutter/material.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/widgets/home_view/date_list_item.dart';
import 'package:provider/provider.dart';

/// List of the last 7 days
class LastWeekList extends StatelessWidget {
  const LastWeekList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the list of last week days dateTimes
    List<DateTime> days = Provider.of<HomeModel>(context).getLastWeek();
    return Padding(
      padding: const EdgeInsets.only(right: mediumPadding + smallPadding),
      child: SizedBox(
        height: 30,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          reverse: true,
          itemCount: 7,
          itemBuilder: (context, index) {
            return DateListItem(
              date: days[index],
              isLast: (index == 0),
            );
          },
        ),
      ),
    );
  }
}
