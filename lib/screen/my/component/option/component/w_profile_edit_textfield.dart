import 'package:flutter/material.dart';
import 'package:whoru/screen/auth/join/s_join.dart';

class ProfileEditTextField extends StatelessWidget {
  final OnValueChanged onValueChanged;
  final String labelText;
  final String initialValue;
  final bool? isNicknameChecked;

  const ProfileEditTextField({
    super.key,
    required this.onValueChanged,
    required this.labelText,
    required this.initialValue,
    this.isNicknameChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(labelText),
                ],
              )),
          Expanded(
            flex: labelText == "닉네임" ? 5 : 7,
            child: TextFormField(
              onChanged: onValueChanged,
              textAlign: TextAlign.center,
              initialValue: initialValue,
              readOnly: isNicknameChecked == true ? true : false,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
