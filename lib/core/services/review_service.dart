import 'package:in_app_review/in_app_review.dart';

/// For review related logic
class ReviewService {
  /// Open Google Play Store. Apple App Store review screen
  void openReviewInStore() {
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.openStoreListing(
      // Id not required for android play store
      appStoreId: '1616194863',
    );
  }

  /// Request an actual review
  Future<void> requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}
