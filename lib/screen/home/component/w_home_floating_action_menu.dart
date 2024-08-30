import 'package:flutter/material.dart';

class HomeFloatingActionMenu extends StatelessWidget {
  final String iconName;
  final String label;
  final Color iconColor;
  const HomeFloatingActionMenu(
      {required this.iconName,
      required this.label,
      required this.iconColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/image/${iconName}_icon.png",
              width: 20, height: 20, color: iconColor),
          const SizedBox(
            width: 8,
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
