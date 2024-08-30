import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nav/nav.dart';
import 'package:whoru/app.dart';
import 'package:whoru/screen/chatting/chatroom/controller/c_chatroom_other_provider.dart';

class ChatRoomAppBar extends ConsumerStatefulWidget {
  const ChatRoomAppBar({super.key});

  @override
  ConsumerState<ChatRoomAppBar> createState() => _ChatRoomAppBarState();
}

class _ChatRoomAppBarState extends ConsumerState<ChatRoomAppBar>
    implements PreferredSizeWidget {
  bool isSearchBtnClicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: kToolbarHeight),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      child: isSearchBtnClicked
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      height: 25, width: 25, "assets/image/search_icon.svg"),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                        cursorHeight: 20,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: const InputDecoration(
                          hintText: "메시지 검색",
                          border: InputBorder.none,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearchBtnClicked = false;
                      });
                    },
                    child: const Text(
                      "취소",
                      style: TextStyle(fontSize: 15),
                    ),
                  )
                ],
              ),
            )
          : Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Nav.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: appbarTextColor,
                  ),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ref.watch(chatRoomOtherProvider)!.nickname,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearchBtnClicked = true;
                      });
                    },
                    child: SvgPicture.asset(
                      width: 30,
                      height: 30,
                      "assets/image/search_icon.svg",
                      color: appbarTextColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: GestureDetector(
                    onTap: () => const Drawer(),
                    child: SvgPicture.asset(
                      height: 30,
                      width: 30,
                      "assets/image/exit_icon.svg",
                      color: appbarTextColor,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    // TODO: implement debugDescribeChildren
    throw UnimplementedError();
  }

  @override
  // TODO: implement key
  Key? get key => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();

  @override
  String toStringDeep(
      {String prefixLineOne = '',
      String? prefixOtherLines,
      DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toStringDeep
    throw UnimplementedError();
  }

  @override
  String toStringShallow(
      {String joiner = ', ',
      DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toStringShallow
    throw UnimplementedError();
  }
}

// Container(
//       margin = const EdgeInsets.only(top: kToolbarHeight),
//       padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
//       child = !isSearchBtnClicked
//           ? Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Nav.pop(context);
//                   },
//                   child: const Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     color: appbarTextColor,
//                   ),
//                 ),
//                 const Expanded(
//                     child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "nickname",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ],
//                 )),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isSearchBtnClicked = true;
//                       });
//                     },
//                     child: SvgPicture.asset(
//                       width: 30,
//                       height: 30,
//                       "assets/image/search_icon.svg",
//                       color: appbarTextColor,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                   child: GestureDetector(
//                     onTap: () => const Drawer(),
//                     child: SvgPicture.asset(
//                       height: 30,
//                       width: 30,
//                       "assets/image/menu_icon.svg",
//                       color: appbarTextColor,
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                       height: 25, width: 25, "assets/image/search_icon.svg"),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: TextField(
//                         cursorHeight: 20,
//                         onTapOutside: (event) =>
//                             FocusManager.instance.primaryFocus?.unfocus(),
//                         decoration: const InputDecoration(
//                           hintText: "메시지 검색",
//                           border: InputBorder.none,
//                         )),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isSearchBtnClicked = false;
//                       });
//                     },
//                     child: const Text(
//                       "취소",
//                       style: TextStyle(fontSize: 15),
//                     ),
//                   )
//                 ],
//               ),),
//     )