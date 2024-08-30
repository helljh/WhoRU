import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/screen/home/controller/c_activity_category.dart';
import 'package:whoru/screen/home/controller/c_activity_date.dart';

class HomeDropDownButton extends ConsumerStatefulWidget {
  final List<String> categoryList;
  const HomeDropDownButton({required this.categoryList, super.key});

  @override
  ConsumerState<HomeDropDownButton> createState() => _HomeDropDownButtonState();
}

class _HomeDropDownButtonState extends ConsumerState<HomeDropDownButton> {
  //final List<String> categoryList = ["전체", "식사", "공부", "취미", "기타"];
  late int _selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = 0;
    ref.refresh(activityCategoryStateProvider);
    ref.refresh(activityDateStateProvider);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                  maxHeight: widget.categoryList.length * 50,
                ),
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return ListView.builder(
                    itemCount: widget.categoryList.length,
                    itemBuilder: (context, index) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                            if (widget.categoryList.length == 6) {
                              ref
                                  .read(activityCategoryStateProvider.notifier)
                                  .setActivityCategory(
                                      widget.categoryList[index]);
                            } else {
                              ref
                                  .read(activityDateStateProvider.notifier)
                                  .setActivityDate(widget.categoryList[index]);
                            }

                            Navigator.pop(context);
                          },
                          child: Text(
                            widget.categoryList[index],
                            style: const TextStyle(
                                fontSize: 15, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.categoryList[_selectedIndex],
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(width: 5),
                  const Icon(CupertinoIcons.arrowtriangle_down_fill,
                      size: 12, color: Colors.black38),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
