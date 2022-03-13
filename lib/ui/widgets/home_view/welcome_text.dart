import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:provider/provider.dart';

/// Show welcome message depending on time of day
class WelcomeText extends StatelessWidget {
  const WelcomeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _getWelcomeString(
        context,
        Provider.of<HomeModel>(context).getWelcome(),
      ),
      style: textBody,
    );
  }
}

/// Return text string depending on input (time of day)
/// Implemented this way (in UI) due to localizations requiring context
String _getWelcomeString(BuildContext context, int value) {
  switch (value) {
    case 0:
      return AppLocalizations.of(context)!.goodMorning;
    case 1:
      return AppLocalizations.of(context)!.goodAfternoon;
    case 2:
      return AppLocalizations.of(context)!.goodEvening;
    default:
      return AppLocalizations.of(context)!.goodMorning;
  }
}
