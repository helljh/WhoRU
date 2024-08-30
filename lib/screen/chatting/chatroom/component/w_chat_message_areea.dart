import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/screen/chatting/chatroom/component/w_chat_bubble.dart';
import 'package:whoru/screen/chatting/chatroom/controller/c_chatroom_other_provider.dart';

class ChatMessageArea extends ConsumerWidget {
  const ChatMessageArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fb = FirebaseFirestore.instance;
    final other = ref.watch(chatRoomOtherProvider);
    //print("대화상대 ${other!.nickname}");
    final me = ref.read(userProfileProvider);

    return StreamBuilder(
        stream: fb
            .collection("chatRooms")
            .where("participants", arrayContains: me!.nickname)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: Colors.white);
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text(""));
          }
          List<DocumentSnapshot> chatRooms =
              snapshot.data!.docs.where((element) {
            if (element['participants'] == null) return false;
            List participants = element['participants'];
            return participants.contains(other!.nickname);
          }).toList();

          if (chatRooms.isEmpty) {
            return const Center(child: Text(""));
          }

          String chatRoomId = chatRooms.first.id;

          //print("방 아이디는 $chatRoomId");
          return MessagesStream(chatRoomId: chatRoomId, me: me.nickname);
        });
  }
}

class MessagesStream extends StatelessWidget {
  final String chatRoomId;
  final String me;

  const MessagesStream({super.key, required this.chatRoomId, required this.me});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('sendTime', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          reverse: true,
          children: snapshot.data!.docs.map((doc) {
            return ChatBubble(
                message: doc['text'], isMe: doc['senderNickname'] == me);
          }).toList(),
        );
      },
    );
  }
}
