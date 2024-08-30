import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:whoru/screen/auth/join/s_join.dart';

class AuthBottomButtonArea extends StatelessWidget {
  final bool isLogin;
  final Map<String, dynamic>? joinInfoList;

  const AuthBottomButtonArea(
      {super.key, required this.isLogin, this.joinInfoList});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => isLogin ? null : Nav.pop(context),
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
          onTap: isLogin
              ? () => Nav.push(const JoinScreen(),
                  context: context, navAni: NavAni.Blink)
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(joinInfoList.toString())));
                  print("clicked");
                },
          child: const Text(
            "회원가입",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
