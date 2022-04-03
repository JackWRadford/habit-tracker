import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/core/providers/add_edit_habit_model.dart';
import 'package:habit_tracker/ui/widgets/shared/my_custom_alert_dialog.dart';
import 'package:habit_tracker/ui/widgets/shared/section_time_date_picker.dart';
import 'package:habit_tracker/ui/widgets/shared/section_toggle.dart';
import 'package:provider/provider.dart';

/// NotiTime and NotiToggle options
class NotiSection extends StatelessWidget {
  const NotiSection({Key? key}) : super(key: key);

  /// Used to pad strings in [timeStr]
  String _twoDigits(int n) => n.toString().padLeft(2, "0");

  /// Format time into hh:mm
  String timeStr(DateTime time) {
    return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    AddEditHabitModel _addEditModel =
        Provider.of<AddEditHabitModel>(context, listen: false);
    return Column(
      children: [
        // Notification Toggle
        SectionToggle(
            title: AppLocalizations.of(context)!.enableNoti,
            onChanged: (value) {
              _addEditModel.setNotiToggle(value);
            },
            pos: SettingsPos.top,
            value: Provider.of<AddEditHabitModel>(context).notiToggle),
        // Notificaiton Time selected
        SectionTimeDatePicker(
          label: AppLocalizations.of(context)!.reminderTime,
          pos: SettingsPos.bottom,
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
      ],
    );
  }
}
