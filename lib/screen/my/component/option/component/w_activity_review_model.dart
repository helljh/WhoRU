import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/home/notification/vo/vo_notification_type.dart';
import 'package:whoru/screen/home/vo/vo_activity.dart';

class ReviewModel extends StatefulWidget {
  final String title;
  final String subTitle;
  final List nicknameList;
  final List<TextEditingController> controllerList;
  final bool? isMatching;
  final Activity activity;

  const ReviewModel({
    super.key,
    required this.title,
    required this.subTitle,
    required this.nicknameList,
    required this.controllerList,
    this.isMatching = false,
    required this.activity,
  });

  @override
  State<ReviewModel> createState() => _ReviewModelState();
}

class _ReviewModelState extends State<ReviewModel> {
  late List<bool> isMatchingClicked;

  @override
  void initState() {
    super.initState();
    // 초기화: 모든 버튼의 상태를 false로 설정
    isMatchingClicked = List.filled(widget.nicknameList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
          child: Column(
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                widget.subTitle,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: widget.isMatching != true
                    ? widget.nicknameList.length * 50
                    : widget.nicknameList.length * 75,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemCount: widget.nicknameList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.nicknameList[index],
                            ),
                            widget.isMatching != true
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        height: 30,
                                        child: TextField(
                                          controller:
                                              widget.controllerList[index],
                                          onChanged: (value) {
                                            widget.controllerList[index].text =
                                                value;
                                          },
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          onTapOutside: (event) => FocusManager
                                              .instance.primaryFocus
                                              ?.unfocus(),
                                          decoration: const InputDecoration(
                                              focusedBorder:
                                                  UnderlineInputBorder(),
                                              enabledBorder:
                                                  UnderlineInputBorder()),
                                        ),
                                      ),
                                      const Text("점")
                                    ],
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            isMatchingClicked[index] == false
                                                ? Colors.white
                                                : const Color(0xffC7E5EA),
                                        foregroundColor:
                                            isMatchingClicked[index] == false
                                                ? Colors.black.withOpacity(0.5)
                                                : Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        isMatchingClicked[index] =
                                            !isMatchingClicked[index];
                                      });
                                    },
                                    child: isMatchingClicked[index] == false
                                        ? const Text("희망")
                                        : const Text("취소"))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5)),
                  onPressed: () {
                    savePoint(widget.nicknameList, widget.controllerList);
                    Nav.pop(context);
                    if (widget.isMatching != true) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                              backgroundColor: Colors.white,
                              child: ReviewModel(
                                title: "매칭을 희망하는 유저가 있습니까?",
                                subTitle: "* 희망버튼 클릭 시 상대에게 매칭요청이 전송됩니다",
                                nicknameList: widget.nicknameList,
                                controllerList: widget.controllerList,
                                isMatching: true,
                                activity: widget.activity,
                              ));
                        },
                      );
                    } else {
                      updateFinished();
                      for (int i = 0; i < widget.nicknameList.length; i++) {
                        sendActivityPoint(widget.nicknameList[i]);
                      }

                      for (int i = 0; i < isMatchingClicked.length; i++) {
                        if (isMatchingClicked[i] == true) {
                          sendMatchingRequest(widget.nicknameList[i]);
                        }
                      }
                    }
                  },
                  child: const Text(
                    "저장",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Future<void> savePoint(List<dynamic> nicknameList,
      List<TextEditingController> controllerList) async {
    for (int i = 0; i < nicknameList.length; i++) {
      final document = await fdb
          .collection("point")
          .where("nickname", isEqualTo: nicknameList[i])
          .get();

      if (document.docs.isNotEmpty) {
        int oldPoint = document.docs.first.data()["point"];
        int newPoint = oldPoint + int.parse(controllerList[i].text);
        await fdb
            .collection("point")
            .doc(document.docs.first.id)
            .update({"point": newPoint});
      } else {
        await fdb.collection("point").add({
          "nickname": nicknameList[i],
          "point": int.parse(controllerList[i].text)
        });
      }
    }
  }

  Future<void> sendActivityPoint(String receiverNickname) async {
    await fdb.collection("notification").add({
      "senderId": fauth.currentUser!.uid,
      "senderNickname": widget.activity.nickname,
      "receiverNickname": receiverNickname,
      "type": NotificationType.activity.toString(),
      "time": Timestamp.now(),
      "activityTitle": widget.activity.title
    });
  }

  Future<void> sendMatchingRequest(String nickname) async {
    await fdb.collection("notification").add({
      "senderId": fauth.currentUser!.uid,
      "senderNickname": widget.activity.nickname,
      "receiverNickname": nickname,
      "type": NotificationType.requestMatching.toString(),
      "time": Timestamp.now()
    });
  }

  Future<void> updateFinished() async {
    await fdb
        .collection("activity")
        .doc(widget.activity.id)
        .update({"isFinished": true});
  }
}
