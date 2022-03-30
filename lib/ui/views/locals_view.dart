import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/core/providers/locale_model.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/widgets/shared/section_button.dart';
import 'package:provider/provider.dart';

/// View to manually select a locale
class LocalsView extends StatelessWidget {
  const LocalsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Map of language codes to language names
    Map<Locale, String> _codeLang = {
      const Locale.fromSubtags(languageCode: 'en'):
          AppLocalizations.of(context)!.english,
      const Locale.fromSubtags(languageCode: 'zh'):
          AppLocalizations.of(context)!.chineseSimplified,
    };

    /// Number of supported locals
    int _localsLength = AppLocalizations.supportedLocales.length;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.selectLanguage,
              style: textSubhead),
        ),
        body: ListView.builder(
            itemCount: _localsLength,
            padding: const EdgeInsets.fromLTRB(
                mediumPadding, 0, mediumPadding, largePadding),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Locale locale = AppLocalizations.supportedLocales[index];
              // Check if item's locale is equal to the current app locale
              bool selected = (locale == Localizations.localeOf(context));
              return SectionButton(
                  labelColor: (selected) ? null : myGrey,
                  onPressed: () {
                    // Set selected locale
                    Provider.of<LocaleModel>(context, listen: false)
                        .setLocale(locale);
                  },
                  buttonLabel:
                      (_codeLang[locale] != null) ? _codeLang[locale]! : '',
                  icon: Icon(CupertinoIcons.checkmark_alt,
                      color: (selected)
                          ? Provider.of<ThemeNotifier>(context)
                              .getHighlightColor(false)
                          : Colors.transparent),
                  hasArrow: false,
                  pos: _getPos(index, _localsLength - 1));
            }));
  }

  /// Get settingsPos based on position in list
  SettingsPos _getPos(int i, int max) {
    if (i == 0) {
      return SettingsPos.top;
    } else if (i == max) {
      return SettingsPos.bottom;
    } else {
      return SettingsPos.middle;
    }
  }
}
