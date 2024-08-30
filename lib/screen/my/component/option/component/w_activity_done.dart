import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';

import '../../../../../main.dart';
import '../../../../home/vo/vo_activity.dart';
import 'w_activity_manage_model.dart';

class ActivityDone extends ConsumerWidget {
  const ActivityDone({super.key});

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
                "완료내역",
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
                .where("isFinished", isEqualTo: true)
                .orderBy("time")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(color: Colors.white);
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("완료된 활동이 없습니다");
              }

              final documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final activity = Activity.fromMap(
                      documents[index].data(), documents[index].id);
                  return Container(
                    color: Colors.grey.shade300,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: const EdgeInsets.only(bottom: 5),
                    child: ActivityManageModel(
                      activity: activity,
                      manageType: "done",
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
