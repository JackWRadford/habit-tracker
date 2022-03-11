import 'package:flutter/material.dart';
import 'package:habit_tracker/core/enums/view_state.dart';

/// Defines state (busy,idle) for change notifiers (viewModels)
class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  /// Used to make sure notifyListeners is not called if disposed
  bool _isDisposed = false;

  void setState(ViewState viewState) {
    _state = viewState;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _isDisposed = true;
  }
}
