import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';

import '../../../../../main.dart';
import '../../../../home/activity/component/w_activity_detail_modal.dart';
import '../../../../home/vo/vo_activity.dart';
import 'w_activity_manage_model.dart';

class ActivityParticipation extends ConsumerWidget {
  const ActivityParticipation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "신청 내역",
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: fdb
                .collection("activity")
                .where("players",
                    arrayContains: ref.read(userProfileProvider)!.nickname)
                .orderBy("time")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(color: Colors.white);
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("참여 중인 활동이 없습니다");
              }

              final documents = snapshot.data!.docs;
              List<QueryDocumentSnapshot<Map<String, dynamic>>> newDocuments =
                  [];
              for (int i = 0; i < documents.length; i++) {
                DateTime now = DateTime.now();
                DateTime time = (documents[i]['time'] as Timestamp).toDate();
                if (documents[i]['createrId'] != fauth.currentUser!.uid &&
                    now.compareTo(time) == -1) {
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
                          color: Colors.green.shade50,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          margin: const EdgeInsets.only(bottom: 5),
                          child: ActivityManageModel(
                            activity: activity,
                            manageType: "participation",
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
