import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/home/notification/component/w_notification_list_item.dart';
import 'package:whoru/screen/home/notification/vo/vo_notification.dart';

class NotificationListArea extends ConsumerWidget {
  const NotificationListArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: fdb
          .collection("notification")
          .where("receiverNickname",
              isEqualTo: ref.read(userProfileProvider)!.nickname)
          .orderBy("time", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.white,
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Expanded(child: Center(child: Text("알림이 없습니다")));
        }

        final documents = snapshot.data!.docs;

        return Expanded(
          child: ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index].data();
              final notification =
                  NotificationItem.fromMap(data, documents[index].id);
              return NotificationListItem(
                notification: notification,
              );
            },
          ),
        );
      },
    );
  }
}
