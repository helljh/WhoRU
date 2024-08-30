import 'package:flutter/material.dart';
import 'package:whoru/screen/ranking/vo/vo_ranking.dart';

class RankingSingle extends StatelessWidget {
  final Ranking ranking;
  const RankingSingle({required this.ranking, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const ShapeDecoration(
                          color: Colors.black12, shape: CircleBorder()),
                      child: Text(
                        ranking.rank.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Text(
                      ranking.nickname,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Text(
                  "${ranking.point.toString()}점",
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 1,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
