import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String title;
  final String createrId;
  final String nickname;
  final Timestamp time;
  final String place;
  final String category;
  final String? description;
  final List<dynamic> players;
  final bool? isFinished;

  Activity(this.id, this.title, this.category, this.createrId, this.nickname,
      this.time, this.place, this.description, this.players, this.isFinished);

  factory Activity.fromMap(Map<String, dynamic> activity, String id) {
    return Activity(
        id,
        activity['title'],
        activity['category'],
        activity['createrId'],
        activity['nickname'],
        activity['time'],
        activity['place'],
        activity['description'],
        activity['players'],
        activity['isFinished']);
  }
}
