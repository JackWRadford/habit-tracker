import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';

///standard alert dialog (cupertino for iOS, material for Android)
///for system style alerts
class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;

  ///if empty then no cancel action
  final String cancelActionText;
  final String defaultActionText;

  ///paints default action red if destructive
  final bool isDestructive;
  final Function() defaultActionOnPressed;

  const MyAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.cancelActionText,
    required this.defaultActionText,
    required this.isDestructive,
    required this.defaultActionOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Platform.isIOS)
        ? CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              if (cancelActionText.isNotEmpty)
                CupertinoDialogAction(
                  child: Text(cancelActionText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(defaultActionText),
                onPressed: defaultActionOnPressed,
                isDestructiveAction: isDestructive,
              ),
            ],
          )
        : AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(mediumRadius),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              content,
            ),
            actions: <Widget>[
              if (cancelActionText.isNotEmpty)
                TextButton(
                  child: Text(
                    cancelActionText,
                    style: textHeadline,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              TextButton(
                child: Text(
                  defaultActionText,
                  style: textHeadline.copyWith(
                    color:
                        (isDestructive) ? CupertinoColors.destructiveRed : null,
                  ),
                ),
                onPressed: defaultActionOnPressed,
              ),
            ],
          );
  }
}
