import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:habit_tracker/core/helper/helper_functions.dart';
import 'package:habit_tracker/core/providers/iap_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:habit_tracker/ui/widgets/pro_view/purchase_button.dart';
import 'package:habit_tracker/ui/widgets/shared/my_alert_dialog.dart';
import 'package:habit_tracker/ui/widgets/shared/underline_btn.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Section in pro view, includes pro button, terms, privacy and restore
class ProBtnSection extends StatelessWidget {
  const ProBtnSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(largeRadius),
        topRight: Radius.circular(largeRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(mediumRadius),
              topRight: Radius.circular(mediumRadius),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              UIHelper.verticalSpaceSmall(),
              Text(AppLocalizations.of(context)!.oneTime, style: textFootnote),
              // Purchase button
              const PurchaseButton(),
              UIHelper.verticalSpaceSmall(),
              // Terms of service and privacy policy
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UnderlineBtn(
                    text: AppLocalizations.of(context)!.terms,
                    onTap: () async {
                      const String urlString =
                          'https://jackwradford.com/#/habittracker/terms';
                      // Try to open external link to terms of service
                      if (await canLaunch(urlString)) {
                        await launch(urlString);
                      } else {
                        myPrint('error launching $urlString');
                        throw "Could not launch $urlString";
                      }
                    },
                  ),
                  Text(
                    ' ${AppLocalizations.of(context)!.and} ',
                    style: textFootnote.copyWith(
                      color: myGrey,
                    ),
                  ),
                  UnderlineBtn(
                    text: AppLocalizations.of(context)!.privacyPolicy,
                    onTap: () async {
                      const String urlString =
                          'https://jackwradford.com/#/habittracker/privacy';
                      // Try to open external link to privacy policy
                      if (await canLaunch(urlString)) {
                        await launch(urlString);
                      } else {
                        myPrint('error launching $urlString');
                        throw "Could not launch $urlString";
                      }
                    },
                  ),
                ],
              ),
              UIHelper.verticalSpaceMedium(),
              // Restore button
              UnderlineBtn(
                text: AppLocalizations.of(context)!.restorePurchases,
                onTap: () async {
                  // Restore purchases
                  await Provider.of<InAppPurchaseModel>(context, listen: false)
                      .restorePurchases();
                  // Show restored purchases dialog
                  showDialog(
                    context: context,
                    builder: (context) => MyAlertDialog(
                      title: AppLocalizations.of(context)!.restored,
                      content: AppLocalizations.of(context)!.restoredDesc,
                      cancelActionText: '',
                      defaultActionText: AppLocalizations.of(context)!.okay,
                      isDestructive: false,
                      defaultActionOnPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
              UIHelper.verticalSpaceMedium(),
            ],
          ),
        ),
      ),
    );
  }
}
