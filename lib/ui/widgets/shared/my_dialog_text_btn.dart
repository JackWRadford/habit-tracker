import 'package:flutter/material.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:provider/provider.dart';

///used for dialogs that require actions
class MyDialogTextBtn extends StatelessWidget {
  final String text;
  final Function() onTap;

  const MyDialogTextBtn({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.all(
            mediumPadding,
          ),
          decoration: BoxDecoration(
            color: Provider.of<ThemeNotifier>(context).getHighlightColor(false),
            borderRadius: const BorderRadius.all(
              Radius.circular(largeRadius),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: textHeadline.copyWith(
                color:
                    Provider.of<ThemeNotifier>(context).getHighlightColor(true),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
