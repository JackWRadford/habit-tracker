import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:provider/provider.dart';

/// Widget to add and edit notes for a habit
class NotesSection extends StatefulWidget {
  final Habit habit;
  const NotesSection({Key? key, required this.habit}) : super(key: key);

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  final TextEditingController _controllerNotes = TextEditingController();

  @override
  void initState() {
    // Set init notes value from habit
    _controllerNotes.text = widget.habit.notes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(mediumRadius))),
      child: Padding(
        padding: const EdgeInsets.all(mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.notes, style: textCallout),
            UIHelper.verticalSpaceSmall(),
            TextFormField(
              onChanged: (value) {
                widget.habit.notes = value;
                // TODO maybe dont call notifyListeners here
                Provider.of<HomeModel>(context, listen: false)
                    .updateHabit(widget.habit);
              },
              controller: _controllerNotes,
              keyboardType: TextInputType.text,
              style: textBody,
              maxLines: null,
              cursorColor:
                  Provider.of<ThemeNotifier>(context).getHighlightColor(false),
              decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: Provider.of<ThemeNotifier>(context).getCardColor(),
                contentPadding: const EdgeInsets.all(0),
                hintText: AppLocalizations.of(context)!.notesHint,
                hintStyle: textBody,
                errorStyle: textFootnote.copyWith(
                  color: Colors.red,
                ),
                helperStyle: textBody,
              ),
              autofocus: false,
            ),
          ],
        ),
      ),
    );
  }
}
