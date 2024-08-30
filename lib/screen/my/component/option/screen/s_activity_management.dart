import 'package:flutter/material.dart';
import 'package:whoru/screen/my/component/option/component/w_activity_done.dart';
import 'package:whoru/screen/my/component/option/component/w_activity_participation.dart';
import 'package:whoru/screen/my/component/option/component/w_activity_progress.dart';
import 'package:whoru/screen/my/component/option/component/w_activity_recruiting.dart';

class ActivityManagementScreen extends StatelessWidget {
  const ActivityManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ActivityProgress(),
            ),
            Expanded(
              child: ActivityRecruiting(),
            ),
            Expanded(
              child: ActivityParticipation(),
            ),
            Expanded(
              child: ActivityDone(),
            )
          ],
        ),
      ),
    );
  }
}
