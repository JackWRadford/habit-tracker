import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:habit_tracker/ui/widgets/shared/my_dialog_text_btn.dart';

/// My custom app alertDialog
class MyCustomAlertDialog extends StatelessWidget {
  final String title;
  final String actionLabel;
  final Function() actionTap;
  final Widget mainContent;
  final String? cancelLabel;
  final Function()? cancelTap;

  const MyCustomAlertDialog({
    Key? key,
    required this.title,
    required this.actionLabel,
    required this.actionTap,
    required this.mainContent,
    this.cancelTap,
    this.cancelLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          largeRadius,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
      title: Center(
        child: Text(
          title,
          style: textHeadline,
          textAlign: TextAlign.center,
        ),
      ),
      content: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            mainContent,
            UIHelper.verticalSpaceMedium(),
            // Action button
            MyDialogTextBtn(
              text: actionLabel,
              onTap: actionTap,
            ),
            // Cancel button
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (cancelTap != null)
                  ? cancelTap
                  : () {
                      Navigator.of(context).pop();
                    },
              child: Padding(
                padding: const EdgeInsets.all(mediumPadding),
                child: Text(
                  (cancelLabel != null)
                      ? cancelLabel!
                      : AppLocalizations.of(context)!.cancel,
                  style: textSubhead.copyWith(
                    color: myGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
