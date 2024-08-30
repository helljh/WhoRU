import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoru/screen/chatting/vo/vo_chatroom_list.dart';

class SingleChatRoom extends StatelessWidget {
  final ChatRoom chatRoom;
  const SingleChatRoom({required this.chatRoom, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: const Icon(
              CupertinoIcons.person,
              size: 15,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatRoom.nickname,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        chatRoom.lastChat,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const Expanded(child: Text("")),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(chatRoom.lastTime)],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
