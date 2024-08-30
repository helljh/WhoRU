import 'package:flutter/material.dart';

import 'component/w_ranking_body.dart';

class RangkingScreen extends StatelessWidget {
  const RangkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "랭킹",
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: false,
      ),
      body: const RankingBody(),
    );
  }
}
