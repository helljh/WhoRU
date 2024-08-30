import 'package:flutter/material.dart';
import 'package:whoru/screen/my/component/w_my_option_area.dart';
import 'package:whoru/screen/my/component/w_my_profile_area.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: MyProfileArea()),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          child: const Divider(
            thickness: 0.5,
            color: Colors.black,
          ),
        ),
        const Expanded(child: MyOptionArea()),
      ],
    );
  }
}
