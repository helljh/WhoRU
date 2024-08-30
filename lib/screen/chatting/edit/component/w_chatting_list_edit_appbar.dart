import 'package:flutter/material.dart';
import 'package:nav/nav.dart';

class ChattingListEditAppBar extends StatelessWidget {
  const ChattingListEditAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Nav.pop(context),
                child: const Text(
                  "완료",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Text(
                "선택 해제",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "편집",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ],
    );
  }
}
