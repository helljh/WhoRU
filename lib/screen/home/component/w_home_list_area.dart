import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/screen/home/activity/component/w_activity_detail_modal.dart';
import 'package:whoru/screen/home/component/w_home_list_item.dart';
import 'package:whoru/screen/home/controller/c_activity_category.dart';
import 'package:whoru/screen/home/controller/c_activity_date.dart';
import 'package:whoru/screen/home/vo/vo_activity.dart';

class HomeListArea extends ConsumerWidget {
  const HomeListArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fb = FirebaseFirestore.instance;
    String category = ref.watch(activityCategoryStateProvider);
    String period = ref.watch(activityDateStateProvider);

    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime endOfWeek = today.add(Duration(days: 7 - today.weekday));

    DateTime startDay;
    DateTime endDay;

    if (period == "오늘") {
      startDay = DateTime(today.year, today.month, today.day, 0, 0, 0);
      endDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    } else if (period == "이번 주") {
      startDay = DateTime(
          startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0);
      endDay =
          DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);
    } else {
      startDay = DateTime(today.year, today.month, 1, 0, 0, 0);
      endDay = DateTime(today.year, today.month + 1, 1).subtract(
          const Duration(days: 1, hours: -23, minutes: -59, seconds: -59));
    }

    Timestamp startTimeStamp = Timestamp.fromDate(startDay);
    Timestamp endTimeStamp = Timestamp.fromDate(endDay);

    // print("선택된 카테고리는 ${ref.watch(activityCategoryStateProvider)}");
    // print("선택된 기간은 ${ref.watch(activityDateStateProvider)}");

    Stream<QuerySnapshot<Map<String, dynamic>>> getActivityStream(
        String category, String period) {
      Query<Map<String, dynamic>> query =
          fb.collection("activity").orderBy("time");

      if (category != "카테고리" && period == "날짜") {
        query = query.where("category", isEqualTo: category);
      } else if (period != "날짜" && category == "카테고리") {
        query = query
            .where("time", isGreaterThanOrEqualTo: startTimeStamp)
            .where("time", isLessThanOrEqualTo: endTimeStamp);
      } else if (category != "카테고리" && period != "날짜") {
        query = query
            .where("category", isEqualTo: category)
            .where("time", isGreaterThanOrEqualTo: startTimeStamp)
            .where("time", isLessThanOrEqualTo: endTimeStamp);
      }

      return query.snapshots();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: StreamBuilder(
          stream: getActivityStream(category, period),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("생성된 활동이 없습니다"));
            } else {
              final documents = snapshot.data!.docs;

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final data = documents[index].data();
                  final activityId = documents[index].id;

                  final activity = Activity.fromMap(data, activityId);

                  return GestureDetector(
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return ActivityDetailDialog(activity: activity);
                        },
                      );
                    },
                    child: HomeListItem(
                      activity: activity,
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
