import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whoru/controller/c_user_profile_provider.dart';
import 'package:whoru/screen/my/component/profile/w_profile_bottom_block.dart';
import 'package:whoru/screen/my/component/profile/w_profile_top_block.dart';

class MyProfileArea extends ConsumerWidget {
  const MyProfileArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    if (profile == null) {
      return const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 1.0,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ProfileTopBlock(userProfile: profile),
          ProfileBottomBlock(userProfile: profile),
        ],
      ),
    );
  }
}
