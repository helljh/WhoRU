import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whoru/screen/home/notification/vo/vo_notification_type.dart';

class NotificationItem {
  final String id;
  final String receiverId;
  final String receiverNickname;
  final String senderNickname;
  final String senderId;
  final NotificationType type;
  final Timestamp time;
  final String? activityTitle;
  final int? possiblePeople;
  final bool? replied;
  final String? answer;

  NotificationItem(
      {required this.id,
      required this.receiverId,
      required this.receiverNickname,
      required this.senderNickname,
      required this.senderId,
      required this.type,
      required this.time,
      this.activityTitle,
      this.possiblePeople,
      this.replied,
      this.answer});

  factory NotificationItem.fromMap(
      Map<String, dynamic> notification, String id) {
    return NotificationItem(
        id: id,
        receiverId: notification['receiverId'] ?? "",
        receiverNickname: notification['receiverNickname'],
        senderNickname: notification['senderNickname'],
        senderId: notification['senderId'],
        type: NotificationType.fromString(notification['type']),
        time: notification['time'],
        activityTitle: notification['activityTitle'] ?? "",
        possiblePeople: notification['possiblePeople'] ?? 0,
        replied: notification['replied'] ?? false,
        answer: notification['answer'] ?? "");
  }
}
