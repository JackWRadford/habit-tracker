import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/add_edit_habit_model.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:habit_tracker/ui/widgets/add_edit_habit_view/color_select.dart';
import 'package:habit_tracker/ui/widgets/add_edit_habit_view/days_select.dart';
import 'package:habit_tracker/ui/widgets/add_edit_habit_view/delete_btn.dart';
import 'package:habit_tracker/ui/widgets/add_edit_habit_view/noti_section.dart';
import 'package:habit_tracker/ui/widgets/add_edit_habit_view/reset_btn.dart';
import 'package:habit_tracker/ui/widgets/shared/section_input.dart';
import 'package:provider/provider.dart';

/// For adding or editing habits
///
/// [habit] is not null if editing and null if adding
class AddEditHabitView extends StatefulWidget {
  final Habit? habit;
  const AddEditHabitView({Key? key, this.habit}) : super(key: key);

  @override
  State<AddEditHabitView> createState() => _AddEditHabitViewState();
}

class _AddEditHabitViewState extends State<AddEditHabitView> {
  final TextEditingController _controllerTitle = TextEditingController();

  @override
  void initState() {
    // Set initial values of the current habit for editing if habit is non-null
    if (widget.habit != null) {
      AddEditHabitModel _addEditHabitModel =
          Provider.of<AddEditHabitModel>(context, listen: false);
      // Title
      _controllerTitle.text = widget.habit!.title;
      // Color
      _addEditHabitModel.selectedColor = widget.habit!.color;
      // Days
      _addEditHabitModel.selectedDays = widget.habit!.requiredDays;
      // Notification time
      _addEditHabitModel.selectedTime = widget.habit!.notiTime;
      // Notification toggle
      _addEditHabitModel.notiToggle = widget.habit!.notiToggle;
      // Notification body
      _addEditHabitModel.notiBody = widget.habit!.notiBody;
    }
    super.initState();
  }

  /// Used to pad strings in [timeStr]
  String _twoDigits(int n) => n.toString().padLeft(2, "0");

  /// Format time into hh:mm
  String timeStr(DateTime time) {
    return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
  }

  /// Update parameters of new or existing habit [h]
  void _setHabitParams(Habit h) {
    AddEditHabitModel _addEditHabitModel =
        Provider.of<AddEditHabitModel>(context, listen: false);
    h.title = _controllerTitle.text;
    h.color = _addEditHabitModel.selectedColor;
    h.requiredDays = _addEditHabitModel.selectedDays;
    h.notiTime = _addEditHabitModel.selectedTime;
    h.notiToggle = _addEditHabitModel.notiToggle;
    h.notiBody = _addEditHabitModel.notiBody;
  }

  @override
  Widget build(BuildContext context) {
    AddEditHabitModel _addEditHabitModel =
        Provider.of<AddEditHabitModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel button
            TextButton(
              onPressed: () {
                _addEditHabitModel.resetSelected();
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: textCaption1.copyWith(color: myGrey),
              ),
            ),
            // View title
            Text(
              (widget.habit != null)
                  ? AppLocalizations.of(context)!.editHabit
                  : AppLocalizations.of(context)!.createHabit,
              style: textFootnote,
            ),
            // Save or done button
            TextButton(
              onPressed: () async {
                if (widget.habit != null) {
                  // Update habit
                  _setHabitParams(widget.habit!);
                  Provider.of<HomeModel>(context, listen: false)
                      .updateHabit(widget.habit!);
                  _addEditHabitModel.updateNotifications(
                      widget.habit!, context);
                } else {
                  // Create new habit
                  Habit newHabit = Habit();
                  _setHabitParams(newHabit);
                  // Need id for notifications id
                  int id = await Provider.of<HomeModel>(context, listen: false)
                      .addNewHabit(newHabit);
                  newHabit.id = id;
                  _addEditHabitModel.updateNotifications(newHabit, context);
                }
                _addEditHabitModel.resetSelected();
                Navigator.of(context).pop();
              },
              child: Text(
                (widget.habit != null)
                    ? AppLocalizations.of(context)!.save
                    : AppLocalizations.of(context)!.done,
                style: textCaption1.copyWith(color: myGrey),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.verticalSpaceSmall(),
              // Title text input section
              SectionInput(
                pos: SettingsPos.solo,
                textEditingController: _controllerTitle,
                maxLength: null,
                maxLines: 1,
                suffix: null,
                hintText: AppLocalizations.of(context)!.title,
                textInputType: TextInputType.text,
                validator: (value) {},
                onSaved: (value) {},
                textAlign: TextAlign.left,
              ),
              UIHelper.verticalSpaceMedium(),
              // Colour select
              const ColorSelect(),
              NotiSection(habit: widget.habit),
              // Day select
              const DaysSelect(),
              (widget.habit != null)
                  ? Column(
                      children: [
                        UIHelper.verticalSpaceLarge(),
                        Resetbtn(habit: widget.habit!),
                        UIHelper.verticalSpaceMedium(),
                        DeleteBtn(habit: widget.habit!),
                      ],
                    )
                  : Container(),
              UIHelper.verticalSpaceLarge(),
              UIHelper.verticalSpaceLarge(),
            ],
          ),
        ),
      ),
    );
  }
}
