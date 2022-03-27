import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';

/// Card to show a pro feature
class ProFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData iconData;

  const ProFeatureCard({
    Key? key,
    required this.title,
    required this.description,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(mediumRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(mediumPadding),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.all(smallPadding),
                decoration: BoxDecoration(
                  color: myTrustBlue.withOpacity(0.1),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(smallRadius)),
                ),
                child: Icon(
                  iconData,
                  color: myTrustBlue,
                )),
            UIHelper.horizontalSpaceMedium(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: textHeadline,
                    textAlign: TextAlign.start,
                  ),
                  UIHelper.verticalSpaceVerySmall(),
                  // Description
                  Text(
                    description,
                    style: textFootnote.copyWith(color: myGrey),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
