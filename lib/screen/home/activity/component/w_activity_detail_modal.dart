import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nav/nav.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/chatting/chatroom/controller/c_chatroom_other_provider.dart';
import 'package:whoru/screen/chatting/chatroom/s_chat_room.dart';
import 'package:whoru/screen/chatting/vo/vo_chat_other.dart';
import 'package:whoru/screen/home/activity/controller/c_activity_update.dart';
import 'package:whoru/screen/home/activity/screen/s_activity_create.dart';
import 'package:whoru/screen/home/notification/vo/vo_notification_type.dart';
import 'package:whoru/screen/home/vo/vo_activity.dart';

class ActivityDetailDialog extends ConsumerWidget {
  final Activity activity;
  const ActivityDetailDialog({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String time =
        DateFormat("yyyy년 M월 d일 a hh:mm", "ko").format(activity.time.toDate());

    int totalPlayers = activity.players.length;
    int currentPlyers = 0;
    if (activity.players.length != 1) {
      for (var i = 0; i < activity.players.length; i++) {
        if (activity.players[i] != "") {
          currentPlyers++;
        }
      }
    }
    return Stack(children: [
      GestureDetector(
        onTap: () => Nav.pop(context),
        child: Container(color: Colors.black.withOpacity(0.5)),
      ),
      Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width * 0.95,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.person_alt_circle,
                          color: Colors.white,
                        ),
                        Text(
                          " ${activity.nickname}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    activity.createrId != fauth.currentUser!.uid
                        ? GestureDetector(
                            onTap: () => Nav.pop(context),
                            child: const Icon(
                              CupertinoIcons.xmark_circle,
                              color: Colors.white,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              ref
                                  .read(activityUpdateStateProvider.notifier)
                                  .setUpdateActivity(activity);

                              Nav.push(
                                  ActivityCreateSreen(
                                    category: activity.category,
                                  ),
                                  navAni: NavAni.Blink,
                                  context: context);
                            },
                            child: const Text(
                              "수정",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          activity.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.person_2, size: 12),
                        Text(" $currentPlyers/$totalPlayers "),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.clock, size: 12),
                        Text(" $time"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.placemark, size: 12),
                        Text(" ${activity.place}"),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                    ),
                    if (activity.description == null)
                      const Text("")
                    else
                      Text(activity.description!),
                    const SizedBox(height: 20),
                    if (activity.createrId != fauth.currentUser!.uid)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black54,
                                  backgroundColor: Colors.white),
                              onPressed: () {
                                Other other = Other(
                                    activity.createrId, activity.nickname);

                                ref
                                    .read(chatRoomOtherProvider.notifier)
                                    .setChatOther(other);

                                Nav.push(const ChatRoomScreen(),
                                    context: context, navAni: NavAni.Blink);
                              },
                              child: const Text("채팅")),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: primaryColor),
                              onPressed: () {
                                activityApply(
                                    context, ref, totalPlayers - currentPlyers);
                              },
                              child: const Text("신청")),
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Future<void> activityApply(
      BuildContext context, WidgetRef ref, int possiblePeople) async {
    final fdb = FirebaseFirestore.instance;
    final fauth = FirebaseAuth.instance;

    await fdb.collection("notification").add({
      "senderId": fauth.currentUser!.uid,
      "receiverId": activity.createrId,
      "receiverNickname": activity.nickname,
      "senderNickname": ref.read(userProfileProvider)!.nickname,
      "type": NotificationType.activityApply.toString(),
      "time": Timestamp.now(),
      "activityTitle": activity.title,
      "possiblePeople": possiblePeople,
    }).then((value) {
      Nav.pop(context);
      Fluttertoast.showToast(
        msg: "신청 완료되었습니다!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    });
  }
}
