import 'package:flutter/material.dart';

import 'w_ranking_block.dart';

class RankingBody extends StatelessWidget {
  const RankingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        //TimerBlock(),
        RankingBlock(),
      ],
    );
  }
}
