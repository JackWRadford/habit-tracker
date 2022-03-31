import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/ui/helper/route_view_args.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:habit_tracker/ui/widgets/habit_view/chart_section.dart';
import 'package:habit_tracker/ui/widgets/habit_view/general_stats_section.dart';
import 'package:habit_tracker/ui/widgets/habit_view/heatmap/heat_map_section.dart';
import 'package:provider/provider.dart';

class HabitView extends StatefulWidget {
  final Habit habit;
  const HabitView({Key? key, required this.habit}) : super(key: key);

  @override
  State<HabitView> createState() => _HabitViewState();
}

class _HabitViewState extends State<HabitView> {
  @override
  void initState() {
    // Set selectedHabit
    Provider.of<HomeModel>(context, listen: false)
        .setSelectedHabit(widget.habit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Habit h = Provider.of<HomeModel>(context).selectedHabit;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: Provider.of<ThemeNotifier>(context).getCardColor(),
        centerTitle: true,
        title: Text(h.title, style: textBody),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
            onPressed: () {
              // Open add edit view and pass habit
              Navigator.pushNamed(
                context,
                '/addEditHabitView',
                arguments: AddEditHabitArgs(habit: h),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
          child: Column(
            children: [
              // Stats (total done, times missed, % last month, % last year)
              GeneralStatsSection(habit: h),
              UIHelper.verticalSpaceMedium(),
              // Total % chart (last month, year)
              ChartSection(habit: h),
              UIHelper.verticalSpaceMedium(),
              // Last year heatmap
              HeatMapSection(h: h),
              UIHelper.verticalSpaceLarge(),
            ],
          ),
        ),
      ),
    );
  }
}
