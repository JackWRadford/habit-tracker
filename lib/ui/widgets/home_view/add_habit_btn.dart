import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/core/providers/settings_model.dart';
import 'package:habit_tracker/ui/helper/route_view_args.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:provider/provider.dart';

/// Button to show add habit view
class AddHabitBtn extends StatelessWidget {
  const AddHabitBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPro = Provider.of<SettingsModel>(context).isUserPro();

    return IconButton(
      onPressed: () async {
        int count = await Provider.of<HomeModel>(context, listen: false)
            .getHabitsCount();
        // Navigate to add/ edit habit view
        if (isPro || count < 2) {
          Navigator.pushNamed(
            context,
            '/addEditHabitView',
            arguments: AddEditHabitArgs(),
          );
        } else {
          // Navigate to pro view
          Navigator.pushNamed(
            context,
            '/proView',
          );
        }
      },
      icon: const Icon(CupertinoIcons.add, color: myGrey),
    );
  }
}
