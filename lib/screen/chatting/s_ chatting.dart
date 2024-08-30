import 'package:flutter/material.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/chatting/component/w_chatting_appbar.dart';
import 'package:whoru/screen/chatting/component/w_chatting_list_area.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ChattingAppBar(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
          child: TabBar(
            tabs: const [Text("익명"), Text("친구")],
            controller: _tabController,
            labelColor: Colors.black87,
            labelStyle: const TextStyle(fontSize: 20),
            indicatorColor: primaryColor,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: const [ChattingListArea(), ChattingListArea()]),
        )
        //ChatListOptionArea(),
        // Expanded(child: ChattingListArea()),
      ],
    );
  }
}
