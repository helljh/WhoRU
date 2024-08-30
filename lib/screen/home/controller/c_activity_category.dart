import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityCategoryStateProvider =
    StateNotifierProvider<activityCategoryStateHolder, String>((ref) {
  return activityCategoryStateHolder();
});

class activityCategoryStateHolder extends StateNotifier<String> {
  activityCategoryStateHolder() : super("카테고리");

  void setActivityCategory(String category) {
    state = category;
    print("카테고리 $state");
  }
}
