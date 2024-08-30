class Ranking {
  final int rank;
  final String nickname;
  final int point;

  Ranking(this.rank, this.nickname, this.point);

  factory Ranking.fromMap(Map<String, dynamic> data, int index) {
    return Ranking(index, data['nickname'], data['point']);
  }
}
