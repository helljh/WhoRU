import 'package:flutter/material.dart';
import 'package:nav/nav.dart';
import 'package:whoru/screen/home/notification/component/w_notification_list_area.dart';

import '../../../app.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Nav.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: appbarTextColor,
                      )),
                  const SizedBox(width: 5),
                  const Text(
                    "알림",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: appbarTextColor),
                  )
                ],
              ),
            ),
            const NotificationListArea()
          ],
        ),
      ),
    );
  }
}
