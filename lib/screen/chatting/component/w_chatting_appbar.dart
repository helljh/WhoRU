import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nav/nav.dart';
import 'package:whoru/app.dart';
import 'package:whoru/screen/chatting/edit/s_chatting_list_edit.dart';

class ChattingAppBar extends ConsumerStatefulWidget {
  const ChattingAppBar({super.key});

  @override
  ConsumerState<ChattingAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<ChattingAppBar> {
  TextEditingController textController = TextEditingController();
  String searchContent = "";
  bool isSearchBtnClicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: Row(
        children: [
          const Text(
            "채팅",
            style: TextStyle(
                fontSize: 30, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          isSearchBtnClicked
              ? const SizedBox(width: 10)
              : const Expanded(child: Text("")),
          if (isSearchBtnClicked)
            Expanded(
              child: SizedBox(
                height: kToolbarHeight * 0.6,
                child: TextField(
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  cursorHeight: 15,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 10, bottom: kToolbarHeight * 0.6 / 2 - 5),
                    hintText: "검색어를 입력해주세요",
                    hintStyle: const TextStyle(fontSize: 15),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isSearchBtnClicked = false;
                          });
                        },
                        icon: const Icon(
                          CupertinoIcons.xmark,
                          size: 15,
                          color: appbarTextColor,
                        )),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
              ),
            ),
          Row(
            children: [
              if (!isSearchBtnClicked)
                GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearchBtnClicked = true;
                      });
                    },
                    child: SizedBox(
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset(
                          'assets/image/search_icon.svg',
                          color: Colors.black,
                        ))),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  Nav.push(
                    const ChattingListEditScreen(),
                    context: context,
                    navAni: NavAni.Blink,
                  );
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: SvgPicture.asset(
                    'assets/image/settings_icon.svg',
                    color: appbarTextColor,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
