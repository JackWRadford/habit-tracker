import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/settings_pos.dart';
import 'package:habit_tracker/core/helper/helper_functions.dart';
import 'package:habit_tracker/core/providers/settings_model.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:habit_tracker/ui/widgets/shared/section_button.dart';
import 'package:habit_tracker/ui/widgets/shared/section_label.dart';
import 'package:habit_tracker/ui/widgets/shared/section_toggle.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPro = Provider.of<SettingsModel>(context).isUserPro();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings, style: textSubhead),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
          child: Column(
            children: [
              // Pro info button
              (!isPro)
                  ? SectionButton(
                      onPressed: () {
                        // Navigate to pro view
                        Navigator.pushNamed(
                          context,
                          '/proView',
                        );
                      },
                      buttonLabel: AppLocalizations.of(context)!.getPro,
                      icon: const Icon(CupertinoIcons.bolt_fill),
                      hasArrow: true,
                      pos: SettingsPos.solo,
                    )
                  : Container(),

              /// PREFERENCES SECTION
              SectionLabel(
                  labelText: AppLocalizations.of(context)!.preferences),
              SectionToggle(
                title: AppLocalizations.of(context)!.darkMode,
                onChanged: (value) {
                  if (isPro || !value) {
                    Provider.of<ThemeNotifier>(context, listen: false)
                        .setTheme(value);
                  } else {
                    // Navigate to pro view
                    Navigator.pushNamed(
                      context,
                      '/proView',
                    );
                  }
                },
                pos: SettingsPos.solo,
                value: Provider.of<ThemeNotifier>(context).getIsDarkMode(),
              ),

              /// APP SECTION
              SectionLabel(labelText: AppLocalizations.of(context)!.app),
              //send feedback
              SectionButton(
                onPressed: () async {
                  const String urlString =
                      'mailto:jackradfordapps@hotmail.com?subject=&body=';
                  //try to open email
                  if (await canLaunch(urlString)) {
                    await launch(urlString);
                  } else {
                    myPrint('error launching $urlString');
                    throw "Could not launch $urlString";
                  }
                },
                buttonLabel: AppLocalizations.of(context)!.contactDeveloper,
                icon: const Icon(
                  CupertinoIcons.paperplane,
                ),
                hasArrow: true,
                pos: SettingsPos.top,
              ),
              // Rate
              SectionButton(
                onPressed: () async {
                  Provider.of<SettingsModel>(context, listen: false)
                      .openReviewInStore();
                },
                buttonLabel: AppLocalizations.of(context)!.rate,
                icon: const Icon(
                  CupertinoIcons.star,
                ),
                hasArrow: true,
                pos: SettingsPos.middle,
              ),
              // // Language
              // SectionButton(
              //   onPressed: () async {
              //     // Navigate to language view
              //     Navigator.pushNamed(
              //       context,
              //       '/localsView',
              //     );
              //   },
              //   buttonLabel: AppLocalizations.of(context)!.language,
              //   icon: const Icon(
              //     CupertinoIcons.location_north,
              //   ),
              //   hasArrow: true,
              //   pos: SettingsPos.middle,
              // ),
              // Terms and conditions
              SectionButton(
                onPressed: () async {
                  const String urlString =
                      'https://jackwradford.com/#/habittracker/terms';
                  // Try to open external link to privacy policy
                  if (await canLaunch(urlString)) {
                    await launch(urlString);
                  } else {
                    myPrint('error launching $urlString');
                    throw "Could not launch $urlString";
                  }
                },
                buttonLabel: AppLocalizations.of(context)!.terms,
                icon: const Icon(
                  CupertinoIcons.checkmark_shield,
                ),
                hasArrow: true,
                pos: SettingsPos.middle,
              ),
              // Privacy policy
              SectionButton(
                onPressed: () async {
                  const String urlString =
                      'https://jackwradford.com/#/habittracker/privacy';
                  //try to open external link to privacy policy
                  if (await canLaunch(urlString)) {
                    await launch(urlString);
                  } else {
                    myPrint('error launching $urlString');
                    throw "Could not launch $urlString";
                  }
                },
                buttonLabel: AppLocalizations.of(context)!.privacyPolicy,
                icon: const Icon(
                  CupertinoIcons.exclamationmark_shield,
                ),
                hasArrow: true,
                pos: SettingsPos.bottom,
              ),

              /// VERSION
              UIHelper.verticalSpaceMedium(),
              Text(
                '1.0.0 (8)',
                style: textCaption2.copyWith(
                  color: myGrey,
                ),
              ),
              UIHelper.verticalSpaceLarge(),
            ],
          ),
        ),
      ),
    );
  }
}
