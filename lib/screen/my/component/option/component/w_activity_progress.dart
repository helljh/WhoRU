import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';

import '../../../../../main.dart';
import '../../../../home/vo/vo_activity.dart';
import 'w_activity_manage_model.dart';

class ActivityProgress extends ConsumerWidget {
  const ActivityProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "진행 중",
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: fdb
                .collection("activity")
                .where("time", isLessThanOrEqualTo: Timestamp.now())
                .where("isFinished", isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(color: Colors.white);
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("진행 중인 활동이 없습니다");
              }

              final documents = snapshot.data!.docs;
              var newDocuments = [];
              for (int i = 0; i < documents.length; i++) {
                List<dynamic> players = documents[i]['players'];
                String userEmail = ref.read(userProfileProvider)!.nickname;
                if (documents[i]['createrId'] == fauth.currentUser!.uid ||
                    players.contains(userEmail)) {
                  newDocuments.add(documents[i]);
                }
              }

              return ListView.builder(
                itemCount: newDocuments.length,
                itemBuilder: (context, index) {
                  final activity = Activity.fromMap(
                      newDocuments[index].data(), newDocuments[index].id);
                  return Container(
                    color: Colors.red.shade50,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 5),
                    child: ActivityManageModel(
                      activity: activity,
                      manageType: "progress",
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
