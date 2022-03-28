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
      // Title
      _controllerTitle.text = widget.habit!.title;
      // Color
      Provider.of<AddEditHabitModel>(context, listen: false).selectedColor =
          widget.habit!.color;
      // Days
      Provider.of<AddEditHabitModel>(context, listen: false).selectedDays =
          widget.habit!.requiredDays;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AddEditHabitModel _addEditHabitModel =
        Provider.of<AddEditHabitModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              onPressed: () {
                if (widget.habit != null) {
                  // Update habit
                  widget.habit!.title = _controllerTitle.text;
                  widget.habit!.color = _addEditHabitModel.selectedColor;
                  widget.habit!.requiredDays = _addEditHabitModel.selectedDays;
                  Provider.of<HomeModel>(context, listen: false)
                      .updateHabit(widget.habit!);
                } else {
                  // Create new habit
                  Habit newHabit = Habit(
                      title: _controllerTitle.text,
                      color: _addEditHabitModel.selectedColor,
                      requiredDays: _addEditHabitModel.selectedDays);
                  Provider.of<HomeModel>(context, listen: false)
                      .addNewHabit(newHabit);
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
              UIHelper.verticalSpaceMedium(),
              const Divider(color: myGrey, height: 2),
              UIHelper.verticalSpaceMedium(),
              // Day select
              (widget.habit == null)
                  ? const DaysSelect()
                  : DeleteBtn(habit: widget.habit!),
            ],
          ),
        ),
      ),
    );
  }
}
