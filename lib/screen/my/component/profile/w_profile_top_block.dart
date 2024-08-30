import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/auth/vo/vo_user_profile.dart';

class ProfileTopBlock extends ConsumerWidget {
  final UserProfile userProfile;
  const ProfileTopBlock({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<int> getPoint() async {
      final document = await fdb
          .collection("point")
          .where("nickname", isEqualTo: ref.read(userProfileProvider)!.nickname)
          .get();
      if (document.docs.isNotEmpty) {
        int point = document.docs.first.data()['point'];

        return point;
      } else {
        return 0;
      }
    }

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Column(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    "assets/image/카톡프로필.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                userProfile.nickname,
                style: const TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Column(
            children: [
              const Text(
                "내 포인트",
                style: TextStyle(fontSize: 30),
              ),
              FutureBuilder<int>(
                future: getPoint(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Error");
                  } else if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data}점",
                      style: const TextStyle(fontSize: 20),
                    );
                  } else {
                    return const Text("??점");
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
