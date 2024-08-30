import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoru/screen/home/component/w_home_appbar.dart';
import 'package:whoru/screen/home/component/w_home_dropdown_button.dart';
import 'package:whoru/screen/home/component/w_home_list_area.dart';

import 'component/w_home_floating_action_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Column(
          children: [
            HomeAppBar(),
            Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  HomeDropDownButton(
                      categoryList: ["날짜", "오늘", "이번 주", "이번 달"]),
                  HomeDropDownButton(
                      categoryList: ["카테고리", "식사", "공부", "운동", "취미", "기타"])
                ],
              ),
            ),
            Expanded(child: HomeListArea()),
          ],
        ),
        HomeFloatingActionButton(),
      ],
    );
  }
}
