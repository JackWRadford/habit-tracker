import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/add_edit_habit_model.dart';
import 'package:habit_tracker/ui/widgets/shared/my_custom_alert_dialog.dart';
import 'package:habit_tracker/ui/widgets/shared/section_input.dart';
import 'package:habit_tracker/ui/widgets/shared/section_label.dart';
import 'package:habit_tracker/ui/widgets/shared/section_time_date_picker.dart';
import 'package:habit_tracker/ui/widgets/shared/section_toggle.dart';
import 'package:provider/provider.dart';

/// NotiTime and NotiToggle options
class NotiSection extends StatefulWidget {
  final Habit? habit;
  const NotiSection({Key? key, required this.habit}) : super(key: key);

  @override
  State<NotiSection> createState() => _NotiSectionState();
}

class _NotiSectionState extends State<NotiSection> {
  final TextEditingController _controllerBody = TextEditingController();

  /// Used to pad strings in [timeStr]
  String _twoDigits(int n) => n.toString().padLeft(2, "0");

  /// Format time into hh:mm
  String timeStr(DateTime time) {
    return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
  }

  @override
  void initState() {
    // Set noti body if habit is not null
    if (widget.habit != null) {
      if (widget.habit!.notiBody.isNotEmpty) {
        _controllerBody.text = widget.habit!.notiBody;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AddEditHabitModel _addEditModel =
        Provider.of<AddEditHabitModel>(context, listen: false);
    return Column(
      children: [
        SectionLabel(labelText: AppLocalizations.of(context)!.reminders),
        // Notification Toggle
        SectionToggle(
            title: AppLocalizations.of(context)!.enableNoti,
            onChanged: (value) {
              _addEditModel.setNotiToggle(value);
            },
            color: Provider.of<AddEditHabitModel>(context).selectedColor,
            pos: SettingsPos.top,
            value: Provider.of<AddEditHabitModel>(context).notiToggle),
        // Notificaiton Time selected
        SectionTimeDatePicker(
          label: AppLocalizations.of(context)!.reminderTime,
          pos: SettingsPos.middle,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => MyCustomAlertDialog(
                title: AppLocalizations.of(context)!.reminderTime,
                actionLabel: AppLocalizations.of(context)!.done,
                actionTap: () {
                  _addEditModel.setSelecteTime();
                  Navigator.of(context).pop();
                },
                mainContent: SizedBox(
                  height: 180,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    initialDateTime: _addEditModel.selectedTime,
                    onDateTimeChanged: (value) {
                      _addEditModel.currentTime = value;
                    },
                  ),
                ),
              ),
            );
          },
          value: timeStr(Provider.of<AddEditHabitModel>(context).selectedTime),
        ),
        // Notification body input
        SectionInput(
            pos: SettingsPos.bottom,
            textEditingController: _controllerBody,
            maxLength: null,
            maxLines: 1,
            suffix: null,
            hintText: AppLocalizations.of(context)!.notiMessage,
            textInputType: TextInputType.text,
            validator: (value) {},
            onSaved: (value) {},
            onChanged: (value) {
              // Update value
              _addEditModel.notiBody = value as String;
            },
            textAlign: TextAlign.left),
      ],
    );
  }
}
