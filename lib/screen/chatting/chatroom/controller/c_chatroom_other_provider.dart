import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/screen/chatting/vo/vo_chat_other.dart';

final chatRoomOtherProvider =
    StateNotifierProvider<chatRoomOtherHolder, Other?>((ref) {
  return chatRoomOtherHolder();
});

class chatRoomOtherHolder extends StateNotifier<Other?> {
  chatRoomOtherHolder() : super(null);

  void setChatOther(Other other) {
    state = other;
  }
}
