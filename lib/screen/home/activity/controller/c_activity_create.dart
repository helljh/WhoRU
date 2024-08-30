import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityCreateStateProvider =
    StateNotifierProvider<activityCreateStateHolder, List<dynamic>>((ref) {
  return activityCreateStateHolder();
});

class activityCreateStateHolder extends StateNotifier<List<dynamic>> {
  activityCreateStateHolder() : super(List.generate(5, (index) => null));

  void setActivity(int index, dynamic information) {
    state[index] = information;
  }
}
