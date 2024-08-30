import 'package:flutter/material.dart';
import 'package:whoru/screen/chatting/component/w_single_chat_room.dart';
import 'package:whoru/screen/chatting/edit/component/w_chatting_list_edit_appbar.dart';

import '../vo/vo_chatroom_list.dart';

class ChattingListEditScreen extends StatelessWidget {
  const ChattingListEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ChatRoom> chatRoomList = <ChatRoom>[
      ChatRoom("nickname1", "lastChat1", "time1"),
      ChatRoom("nickname2", "lastChat2", "time2"),
      ChatRoom("nickname3", "lastChat3", "time3"),
      ChatRoom("nickname4", "lastChat4", "time4"),
      ChatRoom("nickname1", "lastChat1", "time1"),
      ChatRoom("nickname2", "lastChat2", "time2"),
      ChatRoom("nickname3", "lastChat3", "time3"),
      ChatRoom("nickname4", "lastChat4", "time4"),
      ChatRoom("nickname1", "lastChat1", "time1"),
      ChatRoom("nickname2", "lastChat2", "time2"),
      ChatRoom("nickname3", "lastChat3", "time3"),
      ChatRoom("nickname4", "lastChat4", "time4"),
    ];

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const ChattingListEditAppBar(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                  itemCount: chatRoomList.length,
                  itemBuilder: (context, index) => SingleChatRoom(
                        chatRoom: chatRoomList[index],
                      )),
            ),
          ),
          Container(
            height: 50,
            color: Colors.amber,
          )
        ],
      ),
    ));
  }
}
