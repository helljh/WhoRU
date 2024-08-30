import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nav/nav.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/home/vo/vo_activity.dart';

import 'w_activity_review_model.dart';

class ActivityManageModel extends ConsumerWidget {
  final Activity activity;
  final String manageType;
  const ActivityManageModel(
      {super.key, required this.activity, required this.manageType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String activityTime = DateFormat("M월 d일").format(activity.time.toDate());

    String result = activityTime;

    String date = DateFormat("M-d").format(activity.time.toDate());
    String today = DateFormat("M-d").format(DateTime.now());
    String imageIcon = "food_icon";

    List<int> pointList = [];
    List<TextEditingController> controllerList = [];

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

    if (date.compareTo(today) == 0) {
      result = "오늘";
    } else if (int.parse(date.split("-")[1]) - int.parse(today.split("-")[1]) ==
        1) {
      result = "내일";
    }

    List<dynamic> nicknameList = List.from(activity.players);
    nicknameList.removeWhere((player) =>
        player == "" ||
        player == null ||
        player == ref.read(userProfileProvider)!.nickname);

    for (int i = 0; i < nicknameList.length; i++) {
      controllerList.add(TextEditingController());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  //border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset(
                    "assets/image/$imageIcon.png",
                  ),
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
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
          height: 1,
          width: MediaQuery.of(context).size.width,
          child: const Text(""),
        ),
        if (manageType == "progress" &&
            activity.createrId == fauth.currentUser!.uid)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: GestureDetector(
                onTap: () {
                  if (activity.createrId == fauth.currentUser!.uid) {
                    showCupertinoDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text("활동을 종료하시겠습니까?"),
                          contentTextStyle: const TextStyle(
                              fontSize: 15, color: Color(0xff352F36)),
                          contentPadding:
                              const EdgeInsets.only(left: 15, top: 10),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Nav.pop(context);
                                },
                                child: const Text("취소")),
                            TextButton(
                                onPressed: () {
                                  Nav.pop(context);

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        child: ReviewModel(
                                          title: "활동 포인트를 지급해주세요",
                                          subTitle: "* 0~10점 지급",
                                          nicknameList: nicknameList,
                                          controllerList: controllerList,
                                          activity: activity,
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Text("확인"))
                          ],
                          actionsPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 12),
                        );
                      },
                    );
                  }
                },
                child: const Text("활동 종료 & 평가하기 > ")),
          )
      ],
    );
  }

  Future<void> activityFinish(String id, BuildContext context) async {
    await fdb
        .collection("activity")
        .doc(id)
        .update({"isFinished": true}).then((value) => Nav.pop(context));
  }
}
