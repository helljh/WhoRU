import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityDateStateProvider =
    StateNotifierProvider<activityDateStateHolder, String>((ref) {
  return activityDateStateHolder();
});

class activityDateStateHolder extends StateNotifier<String> {
  activityDateStateHolder() : super("날짜");

  void setActivityDate(String period) {
    state = period;
  }
}
