import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
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
  Color _selectedColor = myRed;

  @override
  void initState() {
    // Set initial values of the current habit for editing if habit is non-null
    if (widget.habit != null) {
      // Title
      _controllerTitle.text = widget.habit!.title;
      // Color
      _selectedColor = widget.habit!.color;
      // Days

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: textFootnote.copyWith(color: myGrey),
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
                  Provider.of<HomeModel>(context, listen: false)
                      .updateHabit(widget.habit!);
                } else {
                  // Create new habit
                  Habit newHabit = Habit(title: _controllerTitle.text);
                  Provider.of<HomeModel>(context, listen: false)
                      .addNewHabit(newHabit);
                }
                Navigator.of(context).pop();
              },
              child: Text(
                (widget.habit != null)
                    ? AppLocalizations.of(context)!.save
                    : AppLocalizations.of(context)!.done,
                style: textFootnote.copyWith(color: myGrey),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: smallPadding),
          child: Column(
            children: [
              // Title text input section
              SectionInput(
                pos: SettingsPos.solo,
                textEditingController: _controllerTitle,
                maxLength: null,
                maxLines: 1,
                suffix: null,
                hintText: 'Habit title',
                textInputType: TextInputType.text,
                validator: (value) {},
                onSaved: (value) {},
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
