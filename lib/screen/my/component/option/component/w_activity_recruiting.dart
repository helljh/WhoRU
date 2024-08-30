import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/home/vo/vo_activity.dart';

import '../../../../home/activity/component/w_activity_detail_modal.dart';
import 'w_activity_manage_model.dart';

class ActivityRecruiting extends StatelessWidget {
  const ActivityRecruiting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "모집 중",
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: fdb
                .collection("activity")
                .where("createrId", isEqualTo: fauth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(color: Colors.white);
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("모집 중인 활동이 없습니다");
              }

              final documents = snapshot.data!.docs;
              List<QueryDocumentSnapshot<Map<String, dynamic>>> newDocuments =
                  [];
              for (int i = 0; i < documents.length; i++) {
                DateTime now = DateTime.now();
                DateTime time = (documents[i]['time'] as Timestamp).toDate();
                if (now.compareTo(time) == -1) {
                  newDocuments.add(documents[i]);
                }
              }
              return ListView.builder(
                  itemCount: newDocuments.length,
                  itemBuilder: (context, index) {
                    final activity = Activity.fromMap(
                        newDocuments[index].data(), newDocuments[index].id);
                    return GestureDetector(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return ActivityDetailDialog(activity: activity);
                          },
                        );
                      },
                      child: Container(
                          color: Colors.yellow.shade50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          margin: const EdgeInsets.only(bottom: 5),
                          child: ActivityManageModel(
                            activity: activity,
                            manageType: "recruiting",
                          )),
                    );
                  });
            },
          ),
        )
      ],
    );
  }
}
