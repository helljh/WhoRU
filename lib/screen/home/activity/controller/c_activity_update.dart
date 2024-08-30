import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../vo/vo_activity.dart';

final activityUpdateStateProvider =
    StateNotifierProvider<activityUpdateStateHolder, Activity?>((ref) {
  return activityUpdateStateHolder();
});

class activityUpdateStateHolder extends StateNotifier<Activity?> {
  activityUpdateStateHolder() : super(null);

  void setUpdateActivity(Activity activity) {
    state = activity;
  }
}
