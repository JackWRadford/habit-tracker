import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/view_state.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/core/providers/iap_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:habit_tracker/ui/widgets/home_view/add_habit_btn.dart';
import 'package:habit_tracker/ui/widgets/home_view/habits_list.dart';
import 'package:habit_tracker/ui/widgets/home_view/last_week_list.dart';
import 'package:habit_tracker/ui/widgets/home_view/settings_btn.dart';
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
    // Init in app purchases (early)
    Provider.of<InAppPurchaseModel>(context, listen: false).initialize();
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
        // title: const WelcomeText(),
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
                        if (snapshot.data!.isNotEmpty) {
                          return HabitsList(habits: snapshot.data!);
                        } else {
                          _noHabits();
                        }
                      }
                      return _noHabits();
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

  /// Widget showing no habits yet
  Widget _noHabits() {
    return Padding(
      padding: const EdgeInsets.only(top: veryLargePadding),
      child: Center(
          child: Text(AppLocalizations.of(context)!.noHabits,
              style: textBody.copyWith(color: myGrey))),
    );
  }
}
