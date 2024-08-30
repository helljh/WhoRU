import 'package:flutter/material.dart';

class TimerBlock extends StatelessWidget {
  const TimerBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "4월 1주차",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text("5일 10시간 20분")
        ],
      ),
    );
  }
}
