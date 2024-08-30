// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/app.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/screen/chatting/chatroom/controller/c_chatroom_other_provider.dart';

class ChatInputArea extends ConsumerWidget {
  const ChatInputArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isClicked = false;
    final TextEditingController editingController = TextEditingController();
    final other = ref.read(chatRoomOtherProvider);
    final me = ref.read(userProfileProvider);

    Future<void> sendMessage(String message) async {
      final fb = FirebaseFirestore.instance;

      var chatRoomsRef = fb.collection("chatRooms");
      var existingChatRoom = await chatRoomsRef
          .where("participants", arrayContains: me!.nickname)
          .get();

      String? chatRoomId;

      for (var doc in existingChatRoom.docs) {
        if ((doc['participants'] as List).contains(other!.nickname)) {
          chatRoomId = doc.id;
          break;
        }
      }

      if (chatRoomId == null) {
        var newChatRoom = await chatRoomsRef.add({
          "participants": [me.nickname, other!.nickname]
        });
        chatRoomId = newChatRoom.id;

        FirebaseFirestore.instance.collection('users').doc(me.id).update({
          'chatRooms': FieldValue.arrayUnion([chatRoomId])
        });

        FirebaseFirestore.instance.collection('users').doc(other.id).update({
          'chatRooms': FieldValue.arrayUnion([chatRoomId])
        });
      }
      fb.collection("chatRooms").doc(chatRoomId).collection("messages").add({
        "text": message,
        "senderId": me.id,
        "senderNickname": me.nickname,
        "sendTime": DateTime.now(),
      }).then((value) => editingController.clear());
    }

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: isClicked ? 0.125 : 0,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
              iconSize: 30,
              color: appbarTextColor,
            ),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: TextFormField(
              controller: editingController,
              scrollPadding: const EdgeInsets.all(5),
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.multiline,
              cursorHeight: 15,
              maxLines: null,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              cursorColor: const Color.fromARGB(255, 1, 106, 192),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  isDense: true,
                  suffixIcon: GestureDetector(
                      onTap: () => sendMessage(editingController.text),
                      child: const Icon(CupertinoIcons.paperplane)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  )),
            ),
          )),
        ],
      ),
    );
  }
}
