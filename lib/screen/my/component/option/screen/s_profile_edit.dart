import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nav/nav.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/auth/vo/vo_user_profile.dart';

import '../component/w_profile_edit_textfield.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final auth = FirebaseAuth.instance;
  final fdb = FirebaseFirestore.instance;

  final formkey = GlobalKey<FormState>();
  final Map<String, dynamic> updatedFields = {};
  bool isNicknameChecked = false;

  late String name;
  late String newNickname;
  late String nickname;
  late String birthday;
  late String mbti;
  late String hobby;

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    UserProfile profile = ref.read(userProfileProvider) as UserProfile;

    if (profile.toString().isEmpty) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileEditTextField(
                    labelText: "이름",
                    initialValue: profile.name,
                    onValueChanged: (value) {
                      if (value != profile.name) {
                        updatedFields['name'] = value;
                      }
                      name = value;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ProfileEditTextField(
                          labelText: "닉네임",
                          initialValue: profile.nickname,
                          onValueChanged: (value) {
                            if (value != profile.nickname) {
                              updatedFields['nickname'] = value;
                            }
                            nickname = value;
                          },
                          isNicknameChecked: isNicknameChecked,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          checkNickname(updatedFields['nickname']);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                              color: isNicknameChecked
                                  ? Colors.grey.shade200
                                  : const Color(0xffC7E5EA),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: const Text("중복확인"),
                        ),
                      )
                    ],
                  ),
                  ProfileEditTextField(
                    initialValue: profile.birthday,
                    onValueChanged: (value) {
                      if (value != profile.birthday) {
                        updatedFields['birthday'] = value;
                      }
                      birthday = value;
                    },
                    labelText: "생년월일",
                  ),
                  ProfileEditTextField(
                    initialValue: profile.mbti,
                    onValueChanged: (value) {
                      if (value != profile.mbti) {
                        updatedFields['mbti'] = value.toUpperCase();
                      }
                      mbti = value;
                    },
                    labelText: "MBTI",
                  ),
                  ProfileEditTextField(
                    initialValue: profile.hobby,
                    onValueChanged: (value) {
                      if (value != profile.hobby) {
                        updatedFields['hobby'] = value;
                      }
                      hobby = value;
                    },
                    labelText: "취미",
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black54,
                            backgroundColor: Colors.white),
                        onPressed: () {
                          Nav.pop(context);
                        },
                        child: const Text("취소")),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor),
                        onPressed: () {
                          if (updatedFields.isEmpty) {
                            showToast("변경된 내용이 없습니다");
                            return;
                          }

                          updateProfile(updatedFields);
                        },
                        child: const Text("저장"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkNickname(String nickname) async {
    if (nickname.isEmpty) {
      showToast("닉네임 변경 후 확인해주세요");
    }
    final nicknameDoc = await fdb
        .collection("users")
        .where("nickname", isEqualTo: nickname)
        .get();

    if (nicknameDoc.docs.isNotEmpty) {
      showToast("이미 존재하는 닉네임입니다");
    } else {
      showToast("사용 가능한 닉네임입니다.");
      setState(() {
        isNicknameChecked = true;
      });
    }
  }

  Future<void> updateProfile(Map<String, dynamic> newProfile) async {
    await fdb
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update(newProfile)
        .then((value) {
      ref.refresh(userProfileProvider);
      showToast("성공적으로 변경되었습니다!");
      Nav.pop(context);
    });
  }
}
