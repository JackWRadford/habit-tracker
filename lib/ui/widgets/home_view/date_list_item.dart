import 'package:flutter/material.dart';
import 'package:habit_tracker/core/providers/locale_model.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Shows the number date and first two letters of the given DateTime
class DateListItem extends StatelessWidget {
  final DateTime date;
  final bool isLast;
  const DateListItem({Key? key, required this.date, required this.isLast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get currently selected language code
    String langCode =
        Provider.of<LocaleModel>(context).selectedLocale.languageCode;
    Color textColor = (isLast)
        ? Provider.of<ThemeNotifier>(context).getHighlightColor(false)
        : myGrey;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: tinyPadding),
      child: SizedBox(
        width: 22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(DateFormat('d').format(date),
                style: textCaption1.copyWith(color: textColor)),
            Text(
                DateFormat('E', langCode)
                    .format(date)
                    .substring(0, 2) // (0,1) for japanese
                    .toUpperCase(),
                style: textCaption2.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
