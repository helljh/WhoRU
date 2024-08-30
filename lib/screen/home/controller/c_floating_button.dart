import 'package:flutter_riverpod/flutter_riverpod.dart';

final floatingButtonStateProvider =
    StateNotifierProvider<FloatingButtonStateHolder, bool>((ref) {
  return FloatingButtonStateHolder();
});

class FloatingButtonStateHolder extends StateNotifier<bool> {
  FloatingButtonStateHolder() : super(false);

  void clickedFloatingButton() {
    state = !state;
  }
}
