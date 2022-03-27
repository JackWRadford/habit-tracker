import 'dart:async';
import 'dart:io';

import 'package:habit_tracker/core/enums/view_state.dart';
import 'package:habit_tracker/core/helper/helper_functions.dart';
import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/settings_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Provider to deal with purchasing and restoring a purchase
class InAppPurchaseModel extends BaseModel {
  /// Settings service
  final SettingsService _settingsService = locator<SettingsService>();
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> subscription;
  bool isAvailable = false;
  final String _iosProductID = 'habittrackeronetimepro'; //do not change
  final String _androidProductID = 'habittrackeronetimepro'; //do not change

  // Restored
  bool _isRestored = false;
  bool get isRestored => _isRestored;
  set isRestored(bool value) {
    setState(ViewState.busy);
    _isRestored = value;
    setState(ViewState.idle);
  }

  // Is purchased
  bool _isPurchased = false;
  bool get isPurchased => _isPurchased;
  set isPurchased(bool value) {
    setState(ViewState.busy);
    _isPurchased = value;
    setState(ViewState.idle);
  }

  // Purchases
  List _purchases = [];
  List get purchases => _purchases;
  set purchases(List value) {
    setState(ViewState.busy);
    _purchases = value;
    setState(ViewState.idle);
  }

  // Products
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;
  set products(List<ProductDetails> value) {
    setState(ViewState.busy);
    _products = value;
    setState(ViewState.idle);
  }

  /// Init
  void initialize() async {
    isAvailable = await _iap.isAvailable();
    if (isAvailable) {
      await _getProducts();
      // await _restorePurchases();
      // await _verifyPurchase();
      subscription = _iap.purchaseStream.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      }, onDone: () {
        subscription.cancel();
      }, onError: (error) {
        myPrint(error);
      });
    }
  }

  /// Listen and deal with purchase stream
  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    myPrint('event');
    for (var purchaseDetails in purchaseDetailsList) {
      myPrint(purchaseDetails.productID);
      if (purchaseDetails.status == PurchaseStatus.pending) {
        myPrint('purchase pending');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          myPrint('error');
          myPrint(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            _isPurchased = true;
            myPrint('purchase successful');
            // Set settings PRO to true in db
            _updateSettingsIsPro();
          } else {
            myPrint('invalid purchase: ' + purchaseDetails.toString());
          }
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            _isRestored = true;
            myPrint('restoration successful');
            // Set settings PRO to true in db
            _updateSettingsIsPro();
          } else {
            myPrint('invalid purchase: ' + purchaseDetails.toString());
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          // Try to complete purchase if pending (trys for a time period then refund)
          myPrint('complete purchse');
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// Verify purchase (use firebase to ensure real reciepts for restoration)
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    //TODO: establish secure connection between firebase and apple servers
    return true;
  }

  // ///check if user has purchased a given product
  // PurchaseDetails? _hasPurchased(String productID) {
  //   return _purchases.firstWhere(
  //     (element) => element.productID == productID,
  //     orElse: () => null,
  //   );
  // }

  /// Get list of products
  Future<void> _getProducts() async {
    Set<String> ids = (Platform.isIOS) ? {_iosProductID} : {_androidProductID};
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    _products = response.productDetails;
    // Test
    myPrint('products: ' + _products.length.toString());
    if (_products.isNotEmpty) {
      myPrint('get ' + _products[0].title);
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    myPrint('pressed restore');
    await _iap.restorePurchases();
  }

  /// Buy a product
  void buyProduct() {
    // Test
    if (_products.isNotEmpty) {
      myPrint('buy ' + _products[0].title);
    }
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: _products[0],
    );
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Update isPro settings to true
  void _updateSettingsIsPro() {
    _settingsService.settings.isPro = true;
    _settingsService.updateSettings();
  }
}
