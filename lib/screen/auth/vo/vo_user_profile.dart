class UserProfile {
  final String id;
  final String email;
  final String name;
  final String nickname;
  final String birthday;
  final String mbti;
  final String hobby;

  UserProfile(
    this.id,
    this.email,
    this.name,
    this.nickname,
    this.birthday,
    this.mbti,
    this.hobby,
  );

  factory UserProfile.fromMap(Map<String, dynamic> profile, String id) {
    return UserProfile(
        id,
        profile['email'],
        profile['name'],
        profile['nickname'],
        profile['birthday'],
        profile['mbti'],
        profile['hobby']);
  }
}
