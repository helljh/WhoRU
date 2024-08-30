import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whoru/screen/home/vo/vo_activity.dart';

class HomeListItem extends StatelessWidget {
  final Activity activity;
  const HomeListItem({required this.activity, super.key});

  @override
  Widget build(BuildContext context) {
    String activityTime = DateFormat("M월 d일").format(activity.time.toDate());

    String result = activityTime;

    String date = DateFormat("M-d").format(activity.time.toDate());
    String today = DateFormat("M-d").format(DateTime.now());

    if (date.compareTo(today) == 0) {
      result = "오늘";
    } else if (int.parse(date.split("-")[1]) - int.parse(today.split("-")[1]) ==
        1) {
      result = "내일";
    }

    String imageIcon = "food_icon";

    if (activity.category == "식사") {
      imageIcon = imageIcon;
    } else if (activity.category == "공부") {
      imageIcon = "study_icon";
    } else if (activity.category == "운동") {
      imageIcon = "health_icon";
    } else if (activity.category == "취미") {
      imageIcon = "hobby_icon";
    } else {
      imageIcon = "etc_icon";
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Image.asset(
                height: 30,
                width: 30,
                "assets/image/$imageIcon.png",
                fit: BoxFit.contain,
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        activity.title,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(CupertinoIcons.clock, size: 12),
                        Text(result),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.placemark, size: 12),
                        Text(activity.place),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
