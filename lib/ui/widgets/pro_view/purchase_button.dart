import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/providers/iap_model.dart';
import 'package:habit_tracker/core/providers/settings_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:provider/provider.dart';

/// Floating action button for starting the purchase flow
class PurchaseButton extends StatelessWidget {
  const PurchaseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Get in app purchase provider
    InAppPurchaseModel iapModel = Provider.of<InAppPurchaseModel>(context);

    /// Weither the user has Pro or not
    bool isPro = Provider.of<SettingsModel>(context).isUserPro();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Purchase PRO
        iapModel.buyProduct();
      },
      child: Card(
        color: myTrustBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              largeRadius,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: mediumPadding,
            horizontal: veryLargePadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (!isPro)
                    ? (iapModel.isAvailable)
                        ? AppLocalizations.of(context)!.continuee
                        : AppLocalizations.of(context)!.storeUnavailable
                    : AppLocalizations.of(context)!.purchased,
                style: textHeadline.copyWith(
                  color: Colors.black,
                ),
              ),
              UIHelper.horizontalSpaceSmall(),
              // Price
              ((!isPro) && (iapModel.isAvailable))
                  ? Padding(
                      padding: const EdgeInsets.only(left: smallPadding),
                      child: Text(
                        (iapModel.products.isNotEmpty)
                            ? iapModel.products[0].price
                            : '-',
                        style: textHeadline.copyWith(color: Colors.black),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
