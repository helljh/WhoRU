import 'package:flutter/material.dart';
import 'package:whoru/main.dart';
import 'package:whoru/screen/ranking/component/w_ranking_single.dart';
import 'package:whoru/screen/ranking/vo/vo_ranking.dart';

class RankingBlock extends StatelessWidget {
  const RankingBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder(
      stream: fdb
          .collection("point")
          .orderBy("point", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.white);
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("값이 없습니다"));
        }

        final documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final ranking = Ranking.fromMap(documents[index].data(), index + 1);
            return RankingSingle(ranking: ranking);
          },
        );
      },
    ));
  }
}
