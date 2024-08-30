import 'package:flutter/material.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/auth/vo/vo_user_profile.dart';

class ProfileBottomBlock extends StatelessWidget {
  final UserProfile userProfile;
  const ProfileBottomBlock({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    String age = userProfile.birthday.toString().split(".")[0];
    age = (DateTime.now().year - int.parse(age) + 1).toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '$age세',
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
          const Text(
            "|",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          Text(
            userProfile.mbti,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
          const Text(
            "|",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          Text(
            userProfile.hobby,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
