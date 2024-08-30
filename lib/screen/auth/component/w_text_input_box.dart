import 'package:flutter/material.dart';
import 'package:whoru/screen/auth/join/s_join.dart';

class AuthTextInputBox extends StatelessWidget {
  final String hintText;
  final bool isPwd;
  final TextEditingController textEditingController;
  final OnValueChanged onValueChanged;

  const AuthTextInputBox({
    required this.hintText,
    required this.isPwd,
    required this.textEditingController,
    required this.onValueChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 40,
          child: TextFormField(
            controller: textEditingController,
            onChanged: onValueChanged,
            textInputAction: hintText == "취미를 입력해주세요"
                ? TextInputAction.done
                : TextInputAction.next,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            textAlignVertical: const TextAlignVertical(y: 1),
            cursorHeight: 15,
            cursorColor: Colors.black54,
            obscureText: isPwd ? true : false,
            decoration: InputDecoration(
              hintText: hintText,
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
    );
  }
}
