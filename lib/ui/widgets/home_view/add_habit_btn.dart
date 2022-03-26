import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/helper/route_view_args.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';

/// Button to show add habit view
class AddHabitBtn extends StatelessWidget {
  const AddHabitBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // Navigate to add/ edit habit view
        Navigator.pushNamed(
          context,
          '/addEditHabitView',
          arguments: AddEditHabitArgs(),
        );
      },
      icon: const Icon(CupertinoIcons.add, color: myGrey),
    );
  }
}
