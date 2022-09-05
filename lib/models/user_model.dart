class User {
  String name;
  String userId;
  String email;
  List<String>? followers;
  List<String>? following;
  String dp;
  String bio;

  User(
      {required this.name,
      required this.dp,
      required this.email,
      required this.followers,
      required this.userId,
      required this.bio,
      required this.following});

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
        name: data['name'],
        bio: data['bio'],
        dp: data['dp'],
        email: data['email'],
        followers: data['followers'],
        userId: data['userId'],
        following: data['following']);
  }

  Map<String,dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'dp': dp,
      'bio':bio,
      'userId':userId, 
      'followers': followers,
      'following': following,
    };
  }
}
