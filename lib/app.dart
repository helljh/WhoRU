import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/screen/chatting/s_%20chatting.dart';
import 'package:whoru/screen/home/s_home.dart';
import 'package:whoru/screen/my/s_my.dart';
import 'package:whoru/screen/ranking/s_ranking.dart';

const Color appbarTextColor = Colors.black54;

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 메인 위젯
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = [
      const HomeScreen(),
      const ChattingScreen(),
      const RangkingScreen(),
      const MyScreen(),
    ];

    return Scaffold(
      backgroundColor: _selectedIndex == 0 || _selectedIndex == 3
          ? Colors.grey.shade200
          : Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Container(child: widgetOptions.elementAt(_selectedIndex))),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        fixedColor: Colors.black87,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble),
            activeIcon: Icon(CupertinoIcons.chat_bubble_fill),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar),
            activeIcon: Icon(CupertinoIcons.chart_bar_fill),
            label: '랭킹',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: '마이',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    ref.read(userProfileProvider);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
