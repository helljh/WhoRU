import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nav/nav.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/home/activity/controller/c_activity_update.dart';
import 'package:whoru/screen/home/activity/screen/s_activity_create.dart';
import 'package:whoru/screen/home/component/w_home_floating_action_menu.dart';
import 'package:whoru/screen/home/controller/c_floating_button.dart';

class HomeFloatingActionButton extends ConsumerWidget {
  const HomeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isFabClicked = ref.watch(floatingButtonStateProvider);
    //Color textColor = Colors.black;
    Color containerColor = Colors.white;
    List<String> categoryList = ["식사", "공부", "운동", "취미", "기타"];

    List<Widget> floatingActionMenus = [
      const HomeFloatingActionMenu(
        iconName: "food",
        label: "식사",
        iconColor: Colors.orange,
      ),
      const HomeFloatingActionMenu(
        iconName: "study",
        label: "공부",
        iconColor: Colors.green,
      ),
      const HomeFloatingActionMenu(
        iconName: "health",
        label: "운동",
        iconColor: Colors.blue,
      ),
      const HomeFloatingActionMenu(
        iconName: "hobby",
        label: "취미",
        iconColor: Colors.purple,
      ),
      const HomeFloatingActionMenu(
        iconName: "etc",
        label: "기타",
        iconColor: Colors.brown,
      ),
    ];

    return Stack(
      children: [
        if (isFabClicked)
          Container(
            color: Colors.black54,
          ),
        if (isFabClicked)
          Positioned(
            right: 5,
            bottom: 90,
            child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                width: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: floatingActionMenus.length,
                  itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        ref.refresh(activityUpdateStateProvider);
                        Nav.push(
                            ActivityCreateSreen(category: categoryList[index]),
                            context: context,
                            navAni: NavAni.Blink);
                        final provider =
                            ref.watch(floatingButtonStateProvider.notifier);
                        provider.clickedFloatingButton();
                      },
                      child: floatingActionMenus[index]),
                )),
          ),
        Positioned(
          right: 5,
          bottom: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
                color: primaryColor, shape: BoxShape.circle),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final provider =
                    ref.watch(floatingButtonStateProvider.notifier);
                provider.clickedFloatingButton();
                // Nav.push(const ActivityCreateSreen(),
                //     context: context, navAni: NavAni.Blink);
              },
              child: AnimatedRotation(
                  turns: isFabClicked ? 0.125 : 0,
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  child: const Icon(Icons.add)),
            ),
          ),
        ),
      ],
    );
  }
}
