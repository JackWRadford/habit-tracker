import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:habit_tracker/ui/widgets/pro_view/pro_btn_section.dart';
import 'package:habit_tracker/ui/widgets/pro_view/pro_feature_card.dart';

/// View to show pro features and purhcase option
class ProView extends StatelessWidget {
  const ProView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  mediumPadding,
                  0,
                  mediumPadding,
                  largePadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: mediumPadding),
                      child: Text.rich(
                        TextSpan(
                          text: '${AppLocalizations.of(context)!.doMore} \n',
                          style: textTitle1,
                          children: <TextSpan>[
                            TextSpan(
                              text: '${AppLocalizations.of(context)!.withh} ',
                              style: textTitle1,
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!.turnPro,
                              style: textTitle1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    UIHelper.verticalSpaceMedium(),
                    // No limits
                    ProFeatureCard(
                      title: AppLocalizations.of(context)!.noLimits,
                      description: AppLocalizations.of(context)!.noLimitsDesc,
                      iconData: CupertinoIcons.infinite,
                    ),
                    UIHelper.verticalSpaceSmall(),
                    //support me
                    ProFeatureCard(
                      title: AppLocalizations.of(context)!.supportMe,
                      description: AppLocalizations.of(context)!.supportMeDesc,
                      iconData: CupertinoIcons.heart_circle_fill,
                    ),
                    UIHelper.verticalSpaceSmall(),
                    //get all future updates
                    ProFeatureCard(
                      title: AppLocalizations.of(context)!.futureUpdates,
                      description:
                          AppLocalizations.of(context)!.futureUpdatesDesc,
                      iconData: CupertinoIcons.rocket_fill,
                    ),
                    UIHelper.verticalSpaceLarge(),
                    UIHelper.verticalSpaceLarge(),
                    UIHelper.verticalSpaceLarge(),
                    UIHelper.verticalSpaceLarge(),
                    UIHelper.verticalSpaceLarge(),
                  ],
                ),
              ),
            ),
            // Purchse, restore, privacy and terms section
            const Align(
              alignment: Alignment.bottomCenter,
              child: ProBtnSection(),
            ),
          ],
        ),
      ),
    );
  }
}
