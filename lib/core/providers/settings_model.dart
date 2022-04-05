import 'package:habit_tracker/core/locator.dart';
import 'package:habit_tracker/core/providers/base_model.dart';
import 'package:habit_tracker/core/services/settings_service.dart';
import 'package:habit_tracker/core/services/review_service.dart';

/// For settings view
class SettingsModel extends BaseModel {
  /// Settings service
  final SettingsService _settingsService = locator<SettingsService>();

  /// Review service
  final ReviewService _reviewService = locator<ReviewService>();

  /// Constructor
  SettingsModel() {
    // Callback from settingsService when settings are updated (purchased pro)
    _settingsService.callBackSettingsModel = () => notifyListeners();
  }

  /// Open app store review page
  void openReviewInStore() {
    _reviewService.openReviewInStore();
  }

  /// Get if user has PRO
  bool isUserPro() {
    return _settingsService.getSettings().isPro;
  }
}
