class ChatRoom {
  final String nickname;
  final String lastChat;
  final String lastTime;
  final String? imgUrl;
  final bool? isMatched;

  ChatRoom(this.nickname, this.lastChat, this.lastTime,
      {this.imgUrl, this.isMatched});
}
