import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nav/nav.dart';
import 'package:whoru/screen/auth/component/w_text_input_box.dart';

import 'component/w_input_text_double_check.dart';

typedef OnValueChanged = Function(String value);

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final formkey = GlobalKey<FormState>();
  bool isEmailChecked = false;
  bool isNicknameChecked = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwCheckController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController mbtiController = TextEditingController();
  final TextEditingController hobbyController = TextEditingController();

  String email = "";
  String pw = "";
  String pwCheck = "";
  String name = "";
  String nickname = "";
  String birthday = "";
  String mbti = "";
  String hobby = "";

  void emailCheck(bool value) {
    isEmailChecked = value;
  }

  void nicknameCheck(bool value) {
    isNicknameChecked = value;
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<void> createUser() async {
    try {
      final newUser = FirebaseAuth.instance;
      UserCredential result = await newUser.createUserWithEmailAndPassword(
          email: email, password: pw);

      if (result.user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(result.user!.uid)
            .set({
          "email": email,
          "name": name,
          "nickname": nickname,
          "birthday": birthday,
          "mbti": mbti.toUpperCase(),
          "hobby": hobby
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: const Text(
      //     "회원가입",
      //     style: TextStyle(
      //       fontSize: 30,
      //     ),
      //   ),
      //   centerTitle: false,
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Text(
                "회원가입",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formkey,
              child: Column(
                children: [
                  InputTextDoubleCheck(
                    hintText: "이메일을 입력해주세요",
                    inputValue: email,
                    textEditingController: emailController,
                    onValueChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    doubleCheck: emailCheck,
                  ),
                  AuthTextInputBox(
                    hintText: "비밀번호를 입력해주세요",
                    isPwd: true,
                    textEditingController: pwController,
                    onValueChanged: (value) {
                      setState(() {
                        pw = value;
                      });
                    },
                  ),
                  AuthTextInputBox(
                    hintText: "비밀번호를 확인해주세요",
                    isPwd: true,
                    textEditingController: pwCheckController,
                    onValueChanged: (value) {
                      setState(() {
                        pwCheck = value;
                      });
                    },
                  ),
                  AuthTextInputBox(
                    hintText: "이름을 입력해주세요",
                    isPwd: false,
                    textEditingController: nameController,
                    onValueChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  InputTextDoubleCheck(
                    hintText: "닉네임을 입력해주세요",
                    inputValue: nickname,
                    textEditingController: nicknameController,
                    onValueChanged: (value) {
                      setState(() {
                        nickname = value;
                      });
                    },
                    doubleCheck: nicknameCheck,
                  ),
                  AuthTextInputBox(
                    hintText: "생년월일을 입력해주세요 ex) 0000.00.00",
                    isPwd: false,
                    textEditingController: birthdayController,
                    onValueChanged: (value) {
                      setState(() {
                        birthday = value;
                      });
                    },
                  ),
                  AuthTextInputBox(
                    hintText: "MBTI를 입력해주세요",
                    isPwd: false,
                    textEditingController: mbtiController,
                    onValueChanged: (value) {
                      setState(() {
                        mbti = value;
                      });
                    },
                  ),
                  AuthTextInputBox(
                    hintText: "취미를 입력해주세요",
                    isPwd: false,
                    textEditingController: hobbyController,
                    onValueChanged: (value) {
                      setState(() {
                        hobby = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Nav.pop(context),
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
                  onTap: () {
                    bool isValidPassword =
                        RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(pw);

                    if (!isEmailChecked) {
                      showToast("이메일 중복확인 해주세요");
                    } else if (!isValidPassword) {
                      showToast("비밀번호는 8자리 이상이어야 하며,\n소문자와 숫자를 모두 포함해야합니다");
                    } else if (pw != pwCheck) {
                      showToast("비밀번호가 일치하지 않습니다");
                    } else if (name.isEmpty) {
                      showToast("이름을 입력해주세요");
                    } else if (!isNicknameChecked) {
                      showToast("닉네임 중복확인 해주세요");
                    } else if (birthday.isEmpty) {
                      showToast("생년월일을 입력해주세요");
                    } else if (!RegExp(r'^\d{4}\.\d{2}\.\d{2}$')
                        .hasMatch(birthday)) {
                      showToast(
                          "생년월일은 년도(4자리).월(2자리).일(2자리)이어야 합니다. 한자리 숫자는 앞에 0을 붙여주세요");
                    } else if (mbti.isEmpty) {
                      showToast("MBTI를 입력해주세요");
                    } else if (!RegExp(r'^(i|e)(n|s)(f|t)(j|p)$')
                        .hasMatch(mbti)) {
                      showToast("올바르지 않은 MBTI입니다");
                    } else if (hobby.isEmpty) {
                      showToast("취미를 입력해주세요");
                    } else {
                      createUser();

                      showToast("회원가입 성공!");
                      Nav.pop(context);
                    }
                  },
                  child: const Text(
                    "회원가입",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
