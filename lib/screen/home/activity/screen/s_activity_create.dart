import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nav/nav.dart';
import 'package:whoru/app.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/home/activity/component/w_create_textfield_area.dart';
import 'package:whoru/screen/home/activity/controller/c_activity_create.dart';
import 'package:whoru/screen/home/activity/controller/c_activity_update.dart';
import 'package:whoru/screen/my/component/option/screen/s_activity_management.dart';

class ActivityCreateSreen extends ConsumerStatefulWidget {
  final String category;
  const ActivityCreateSreen({super.key, required this.category});

  @override
  ConsumerState<ActivityCreateSreen> createState() =>
      _ActivityCreateSreenState();
}

class _ActivityCreateSreenState extends ConsumerState<ActivityCreateSreen> {
  final fdb = FirebaseFirestore.instance;
  final fauth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              ref.read(activityUpdateStateProvider) == null
                  ? "내 활동 생성"
                  : "내 활동 수정",
              style: const TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ListView(children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "카테고리",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.category,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        const CreatTextFieldArea(),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black54,
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    if (ref.watch(
                                            activityUpdateStateProvider) !=
                                        null) {
                                      Nav.pop(context);
                                    } else {
                                      Nav.push(
                                        const App(),
                                        navAni: NavAni.Blink,
                                        context: context,
                                      );
                                    }
                                  },
                                  child: const Text("취소")),
                              const SizedBox(width: 20),
                              Consumer(
                                builder: (context, ref, child) {
                                  if (ref.read(userProfileProvider) == null) {
                                    return const CircularProgressIndicator(
                                      color: Colors.white,
                                    );
                                  } else {
                                    return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: primaryColor),
                                        child: ref.read(
                                                    activityUpdateStateProvider) ==
                                                null
                                            ? const Text("생성")
                                            : const Text("수정"),
                                        onPressed: () {
                                          if (ref.read(
                                                  activityUpdateStateProvider) ==
                                              null) {
                                            List<dynamic> getList = ref.watch(
                                                activityCreateStateProvider);

                                            if (ref.read(userProfileProvider) ==
                                                null) {
                                              print("값이 없음");
                                            } else {
                                              Map<String, dynamic>
                                                  activityInform = {
                                                "nickname": ref
                                                    .watch(userProfileProvider)!
                                                    .nickname,
                                                "createrId": FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                "category": widget.category,
                                                "title": getList[0],
                                                "players": List.generate(
                                                    int.parse(getList[1]),
                                                    (index) {
                                                  if (getList.length > 1) {
                                                    if (index == 0) {
                                                      return ref
                                                          .read(
                                                              userProfileProvider)!
                                                          .nickname;
                                                    } else {
                                                      return "";
                                                    }
                                                  }
                                                  return "";
                                                }),
                                                "time": getList[2],
                                                "place": getList[3],
                                                "description": getList[4],
                                                "isFinished": false,
                                              };

                                              saveActivity(activityInform);
                                            }
                                          } else {
                                            List<dynamic> getList = ref.watch(
                                                activityCreateStateProvider);
                                            final getActivity = ref.read(
                                                activityUpdateStateProvider)!;

                                            // List<String> originalList = [];
                                            // if (getList[1] != null) {
                                            //   if (int.parse(getList[1]) !=
                                            //       getActivity.players.length) {
                                            //     originalList = List.from(
                                            //         getActivity.players);
                                            //     int newLength =
                                            //         int.parse(getList[1]);

                                            //     if (newLength <
                                            //         originalList.length) {
                                            //       originalList.sublist(
                                            //           0, newLength);
                                            //     } else if (newLength >
                                            //         originalList.length) {
                                            //       originalList.length =
                                            //           newLength;
                                            //       for (int i =
                                            //               originalList.length;
                                            //           i < newLength;
                                            //           i++) {
                                            //         originalList[i] = "";
                                            //       }
                                            //     }
                                            //   }
                                            // }

                                            Map<String, dynamic>
                                                activityUpdateInform = {
                                              "title": getList[0] ??
                                                  getActivity.title,
                                              "time": getList[2] ??
                                                  getActivity.time,
                                              "place": getList[3] ??
                                                  getActivity.place,
                                              "description": getList[4] ??
                                                  getActivity.description,
                                              "isFinished": false,
                                            };

                                            updateActivity(activityUpdateInform,
                                                getActivity.id);
                                          }
                                        });
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveActivity(Map<String, dynamic> activity) async {
    try {
      await fdb.collection("activity").add(activity).then((value) {
        Fluttertoast.showToast(
          msg: "저장 성공",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Nav.pop(context);
      });
    } catch (e) {}
  }

  Future<void> updateActivity(Map<String, dynamic> activity, String id) async {
    await fdb.collection("activity").doc(id).update(activity).then((value) {
      Fluttertoast.showToast(
        msg: "수정 성공",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      Nav.push(const ActivityManagementScreen(),
          context: context, navAni: NavAni.Blink);
    });
  }
}
