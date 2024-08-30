import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whoru/screen/auth/join/s_join.dart';

class InputTextDoubleCheck extends StatefulWidget {
  final String hintText;
  final String inputValue;
  final TextEditingController textEditingController;
  final OnValueChanged onValueChanged;
  final Function doubleCheck;

  const InputTextDoubleCheck(
      {required this.hintText,
      required this.inputValue,
      required this.textEditingController,
      required this.onValueChanged,
      required this.doubleCheck,
      super.key});

  @override
  State<InputTextDoubleCheck> createState() => _InputTextDoubleCheckState();
}

class _InputTextDoubleCheckState extends State<InputTextDoubleCheck> {
  bool isEmailChecked = false;
  bool isNicknameChecked = false;
  final fdb = FirebaseFirestore.instance;

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT);
  }

  Future<void> checkEmailExists(String value) async {
    try {
      // 입력된 값과 일치하는 문서를 쿼리
      var querySnapshot =
          await fdb.collection("users").where("email", isEqualTo: value).get();

      if (querySnapshot.docs.isNotEmpty) {
        showToast("중복된 이메일입니다");
      } else {
        showToast("사용 가능한 이메일입니다");
        setState(() {
          isEmailChecked = true;
          widget.doubleCheck(isEmailChecked);
        });
      }
    } catch (e) {
      // 오류 처리
      print('에러: $e');
      return showToast("$e 오류가 발생했습니다");
    }
  }

  Future<void> checkNicknameExists(String value) async {
    try {
      // 입력된 값과 일치하는 문서를 쿼리
      var querySnapshot = await fdb
          .collection("users")
          .where("nickname", isEqualTo: value)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        showToast("중복된 닉네임입니다");
      } else {
        showToast("사용 가능한 닉네임입니다");
        setState(() {
          isNicknameChecked = true;
          widget.doubleCheck(isNicknameChecked);
        });
      }
    } catch (e) {
      // 오류 처리
      print('에러: $e');
      return showToast("$e 오류가 발생했습니다");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 40,
              child: TextFormField(
                onChanged: widget.onValueChanged,
                controller: widget.textEditingController,
                textInputAction: TextInputAction.next,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                textAlignVertical: const TextAlignVertical(y: 1),
                cursorHeight: 15,
                cursorColor: Colors.black54,
                readOnly: isEmailChecked || isNicknameChecked ? true : false,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(fontSize: 15),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(
          width: 5,
        ),
        GestureDetector(
          onTap: !isEmailChecked || !isNicknameChecked
              ? () {
                  switch (widget.hintText) {
                    case "이메일을 입력해주세요":
                      if (widget.inputValue.isEmpty) {
                        showToast("이메일을 입력해주세요");
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(widget.inputValue)) {
                        showToast("이메일이 올바르지 않습니다");
                      } else {
                        print("입력 값은 ${widget.inputValue}");
                        checkEmailExists(widget.inputValue);
                      }
                      break;
                    case "닉네임을 입력해주세요":
                      if (widget.inputValue.isEmpty) {
                        showToast("닉네임을 입력해주세요");
                      } else {
                        checkNicknameExists(widget.inputValue);
                      }
                      break;
                  }
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
                color: isEmailChecked || isNicknameChecked
                    ? Colors.grey.shade300
                    : const Color(0xffC7E5EA),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: const Text("중복확인"),
          ),
        )
      ],
    );
  }
}
