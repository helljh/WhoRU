import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nav/nav.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/screen/auth/login/s_login.dart';
import 'package:whoru/screen/my/component/option/screen/s_activity_management.dart';
import 'package:whoru/screen/my/component/option/screen/s_profile_edit.dart';

class MyOptionArea extends ConsumerStatefulWidget {
  const MyOptionArea({super.key});

  @override
  ConsumerState<MyOptionArea> createState() => _MyOptionAreaState();
}

class _MyOptionAreaState extends ConsumerState<MyOptionArea> {
  final user = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Nav.push(const ProfileEditScreen(),
                      context: context, navAni: NavAni.Blink);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
                child: const Text(
                  "프로필 수정",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  Nav.push(const ActivityManagementScreen(), context: context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
                child: const Text(
                  "내 활동관리",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
                child: const Text(
                  "내 친구관리",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.watch(userProfileProvider);
                  user.signOut();
                  Nav.clearAllAndPush(const LoginScreen(),
                      navAni: NavAni.Blink, context: context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
                child: const Text(
                  "로그아웃",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
