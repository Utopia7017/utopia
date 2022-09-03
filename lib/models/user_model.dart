class User {
  String name;
  String userId;
  String email;
  List<String> followers;
  List<String> following;
  String dp;

  User(
      {required this.name,
      required this.dp,
      required this.email,
      required this.followers,
      required this.userId,
      required this.following});

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
        name: data['name'],
        dp: data['dp'],
        email: data['email'],
        followers: data['followers'],
        userId: data['userId'],
        following: data['following']);
  }

  toJson() {
    return {
      'name': name,
      'email': email,
      'dp': dp,
      'followers': followers,
      'following': following,
    };
  }
}
