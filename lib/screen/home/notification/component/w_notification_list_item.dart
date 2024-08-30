import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/home/notification/vo/vo_notification.dart';
import 'package:whoru/screen/home/notification/vo/vo_notification_type.dart';

class NotificationListItem extends ConsumerStatefulWidget {
  final NotificationItem notification;
  const NotificationListItem({required this.notification, super.key});

  @override
  ConsumerState<NotificationListItem> createState() =>
      _NotificationListItemState();
}

class _NotificationListItemState extends ConsumerState<NotificationListItem> {
  bool isReplySelected = false;
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.notification.time.toDate();
    DateTime now = DateTime.now();
    String date = "";
    late String result;

    if (dateTime.day == now.day) {
      date = "오늘";
    } else if (now.day - dateTime.day == 1) {
      date = "어제";
    } else {
      date = "${dateTime.difference(now).inDays.abs()}일 전";
    }

    if (widget.notification.type.toString() == "activityApply") {
      result = "${widget.notification.senderNickname}님이 참여 요청을 보냈습니다!";
    } else if (widget.notification.type.toString() == "activityReply") {
      if (widget.notification.answer == "수락") {
        result = "${widget.notification.senderNickname}님이 참여 요청을 수락했습니다!";
      } else if (widget.notification.answer == "거절") {
        result = "${widget.notification.senderNickname}님이 참여 요청을 거절했습니다!";
      }
    } else if (widget.notification.type.toString() == "requestMatching") {
      result = "${widget.notification.senderNickname}님이 친구 요청을 보냈습니다!";
    } else if (widget.notification.type.toString() == "acceptMatching") {
      if (widget.notification.answer == "수락") {
        result = "${widget.notification.senderNickname}님이 친구 요청을 수락했습니다!";
      } else if (widget.notification.answer == "거절") {
        result = "${widget.notification.senderNickname}님이 친구 요청을 거절했습니다!";
      }
    } else {
      result = "${widget.notification.senderNickname}님이 포인트를 지급했습니다!";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
          color: widget.notification.replied!
              ? Colors.grey.shade300
              : Colors.white,
          border: Border(
              top: BorderSide(color: Colors.grey.shade300),
              bottom: BorderSide(color: Colors.grey.shade300))),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(30)),
                width: 40,
                height: 40,
                child: SvgPicture.asset(
                  "assets/image/bell_icon.svg",
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                date,
                style: const TextStyle(fontSize: 10),
              )
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result,
                  style: const TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    if (widget.notification.type.toString() !=
                            "requestMatching" &&
                        widget.notification.type.toString() != "acceptMatching")
                      Text(
                        "활동:${widget.notification.activityTitle}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    if (widget.notification.type.toString() == "activityApply")
                      Text(
                        ", 남은 인원:${widget.notification.possiblePeople}명",
                        style: const TextStyle(fontSize: 12),
                      )
                  ],
                ),
                const SizedBox(height: 10),
                !widget.notification.replied! &&
                        (widget.notification.type.toString() ==
                                "activityApply" ||
                            widget.notification.type.toString() ==
                                "requestMatching")
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isReplySelected = true;
                                saveReplied(isReplySelected, false);
                              });
                            },
                            child: Text(
                              "거절",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.red.shade300),
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isReplySelected = true;
                                saveReplied(isReplySelected, true);
                              });
                            },
                            child: Text(
                              "수락",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.green.shade300),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveReplied(bool isReplied, bool answer) async {
    if (isReplied) {
      if (widget.notification.type.toString() != "requestMatching") {
        await fdb
            .collection("notification")
            .doc(widget.notification.id)
            .update({"replied": isReplied}).then((value) {
          fdb.collection("notification").add({
            "senderId": fauth.currentUser!.uid,
            "senderNickname": ref.read(userProfileProvider)!.nickname,
            "receiverId": widget.notification.senderId,
            "receiverNickname": widget.notification.senderNickname,
            "activityTitle": widget.notification.activityTitle,
            "time": Timestamp.now(),
            "answer": answer ? "수락" : "거절",
            "type": NotificationType.activityReply.toString()
          });
        });

        final querySnapshot = await fdb
            .collection("activity")
            .where("title", isEqualTo: "${widget.notification.activityTitle}")
            .get();

        if (querySnapshot.docs.isNotEmpty && answer) {
          final document = querySnapshot.docs.first;
          final activity = document.data();
          print(activity);
          List<dynamic> players = activity['players'] as List<dynamic>;
          for (int i = 0; i < players.length; i++) {
            if (players[i] == "" || players[i] == null) {
              players[i] = widget.notification.senderNickname;
              break;
            }
          }

          fdb.collection("activity").doc(document.id).update({
            "players": players,
          });
        }
      } else {
        await fdb
            .collection("notification")
            .doc(widget.notification.id)
            .update({"replied": isReplied}).then((value) {
          fdb.collection("notification").add({
            "senderId": fauth.currentUser!.uid,
            "senderNickname": ref.read(userProfileProvider)!.nickname,
            "receiverId": widget.notification.senderId,
            "receiverNickname": widget.notification.senderNickname,
            "time": Timestamp.now(),
            "answer": answer ? "수락" : "거절",
            "type": NotificationType.acceptMatching.toString()
          });
        });
      }
    }
  }
}
