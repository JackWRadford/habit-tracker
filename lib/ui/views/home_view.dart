import 'package:flutter/material.dart';
import 'package:habit_tracker/core/enums/view_state.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:habit_tracker/ui/widgets/home_view/add_habit_btn.dart';
import 'package:habit_tracker/ui/widgets/home_view/habit_card/habit_list_item.dart';
import 'package:habit_tracker/ui/widgets/home_view/last_week_list.dart';
import 'package:habit_tracker/ui/widgets/home_view/settings_btn.dart';
import 'package:habit_tracker/ui/widgets/home_view/welcome_text.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  /// App lifecycle logic
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // Update welcome message and habits (notifyListeners)
        Provider.of<HomeModel>(context, listen: false).setState(ViewState.idle);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const SettingsBtn(),
        title: const WelcomeText(),
        actions: const [
          AddHabitBtn(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Last week days row
          const LastWeekList(),
          UIHelper.verticalSpaceSmall(),
          // List of habits
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  FutureBuilder<List<Habit>>(
                    future: Provider.of<HomeModel>(context).getAllHabits(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return HabitListItem(habit: snapshot.data![index]);
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                  UIHelper.verticalSpaceLarge(),
                  UIHelper.verticalSpaceLarge(),
                  UIHelper.verticalSpaceLarge(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
