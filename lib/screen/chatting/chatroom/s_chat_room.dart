import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/chatting/chatroom/component/w_chat_message_areea.dart';
import 'package:whoru/screen/chatting/chatroom/component/w_chatroom_appbar.dart';

import 'component/w_chat_input_area.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  bool isSearchBtnClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: ChatRoomAppBar()),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                  color: Colors.grey.shade300, child: const ChatMessageArea()),
            ),
            const ChatInputArea(),
          ],
        ),
      ),
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView(
          children: const [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              currentAccountPictureSize: Size(80, 80),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/image/pubao.png"),
              ),
              accountName:
                  Text("nickname", style: TextStyle(color: Colors.black45)),
              accountEmail: null,
            )
          ],
        ),
      ),
    );
  }
}
