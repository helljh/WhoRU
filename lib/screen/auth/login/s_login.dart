import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nav/nav.dart';
import 'package:whoru/app.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/screen/auth/component/w_text_input_box.dart';
import 'package:whoru/screen/auth/join/s_join.dart';
import 'package:whoru/screen/home/controller/c_activity_category.dart';

import '../vo/vo_user_profile.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  String id = "";
  String pw = "";

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT);
  }

  Future<void> signIn(BuildContext context, WidgetRef ref) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: id,
        password: pw,
      );

      if (userCredential.user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();
        UserProfile userProfile = UserProfile(
          userCredential.user!.uid,
          userDoc['email'],
          userDoc['name'],
          userDoc['nickname'],
          userDoc['birthday'],
          userDoc['mbti'],
          userDoc['hobby'],
        );

        ref.watch(userProfileProvider.notifier).setUserProfile(userProfile);
        print(ref.read(userProfileProvider)!.nickname);
        Nav.push(const App(), context: context, navAni: NavAni.Blink);
        // ignore: argument_type_not_ass
      }
    } catch (e) {
      print("Failed to sign in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "로그인",
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            AuthTextInputBox(
              hintText: "아이디를 입력해주세요",
              isPwd: false,
              textEditingController: idController,
              onValueChanged: (value) => setState(() {
                id = value;
              }),
            ),
            AuthTextInputBox(
              hintText: "비밀번호를 입력해주세요",
              isPwd: true,
              textEditingController: pwController,
              onValueChanged: (value) => setState(() {
                pw = value;
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    signIn(context, ref);
                    ref.refresh(activityCategoryStateProvider);
                  },
                  child: const Text(
                    "로그인",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "|",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () => Nav.push(const JoinScreen(),
                      context: context, navAni: NavAni.Blink),
                  child: const Text(
                    "회원가입",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
