import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nav/nav.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/screen/chatting/chatroom/controller/c_chatroom_other_provider.dart';
import 'package:whoru/screen/chatting/chatroom/s_chat_room.dart';
import 'package:whoru/screen/chatting/component/w_single_chat_room.dart';
import 'package:whoru/screen/chatting/vo/vo_chat_other.dart';
import 'package:whoru/screen/chatting/vo/vo_chatroom_list.dart';

class ChattingListArea extends ConsumerWidget {
  const ChattingListArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fb = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    List<String> idList = [];
    List<String> nicknameList = [];

    String formatTimestamp(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('a h:mm', "ko").format(dateTime);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: StreamBuilder(
        stream: fb.collection("users").doc(user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (!snapshot.hasData) {
            return const Center(child: Text(""));
          }
          final chatRoomList = snapshot.data!['chatRooms'] as List<dynamic>;
          return ListView.builder(
            itemCount: chatRoomList.length,
            itemBuilder: (context, index) {
              final chatRoomId = chatRoomList[index].toString();
              idList.add(chatRoomId);

              return GestureDetector(
                onTap: () {
                  Other other = Other(idList[index], nicknameList[index]);
                  print("대화상대방은 ${other.nickname}");
                  ref.watch(chatRoomOtherProvider.notifier).setChatOther(other);
                  Nav.push(const ChatRoomScreen(),
                      navAni: NavAni.Blink, context: context);
                },
                child: FutureBuilder(
                  future: fb
                      .collection("chatRooms")
                      .doc(chatRoomId)
                      .collection("messages")
                      .orderBy("sendTime")
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(
                          strokeWidth: 1.0, color: Colors.white);
                    }

                    final messageDoc = snapshot.data!.docs.last;

                    return FutureBuilder(
                      future: fb.collection("chatRooms").doc(chatRoomId).get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 1.0,
                          );
                        }

                        final data = snapshot.data!;
                        final participants =
                            data['participants'] as List<dynamic>;
                        participants.removeWhere((element) {
                          return element ==
                              ref.read(userProfileProvider)!.nickname;
                        });
                        final sendTime = messageDoc['sendTime'] as Timestamp;
                        final formattedSendTime = formatTimestamp(sendTime);
                        nicknameList.add(participants[0].toString());
                        ChatRoom chatRoom = ChatRoom(participants[0].toString(),
                            messageDoc['text'], formattedSendTime);
                        return SingleChatRoom(chatRoom: chatRoom);
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
