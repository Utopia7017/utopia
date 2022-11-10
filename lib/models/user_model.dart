class User {
  String name;
  String userId;
  String email;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> blocked;
  String dp;
  String bio;
  String cp;
  List<dynamic> savedArticles;
  List<dynamic> draftArticles;
  List<dynamic> blockedBy;
  bool isVerified;

  User(
      {required this.name,
      required this.dp,
      required this.email,
      required this.blockedBy,
      required this.blocked,
      required this.followers,
      required this.userId,
      required this.bio,
      required this.cp,
      required this.draftArticles,
      required this.savedArticles,
      required this.isVerified,
      required this.following});

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
        name: data['name'] ?? '',
        blockedBy: data['blockedBy'] ?? '',
        cp: data['cp'] ?? '',
        bio: data['bio'] ?? '',
        dp: data['dp'],
        blocked: data['blocked'] ?? [],
        draftArticles: data['draftArticles'] ?? [],
        savedArticles: data['savedArticles'] ?? [],
        email: data['email'],
        followers: data['followers'] ?? [],
        userId: data['userId'],
        isVerified: data['isVerified'],
        following: data['following'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      'cp': cp,
      'name': name,
      'email': email,
      'dp': dp,
      'bio': bio,
      'userId': userId,
      'blocked': blocked,
      'followers': followers,
      'following': following,
      'draftArticles': [],
      'savedArticles': [],
      'isVerified': false,
      'blockedBy': [],
    };
  }

  changeCoverPhoto(String coverPhotoUrl) {
    cp = coverPhotoUrl;
  }

  changeDisplayPicture(String displayPicture) {
    dp = displayPicture;
  }

  updateSavedArticleList(List<dynamic> list) {
    savedArticles = list;
  }

  updateProfile(String updatedName, String updatedBio) {
    name = updatedName;
    bio = updatedBio;
  }

  blockUser(String uid) {
    if (!blocked.contains(uid)) {
      blocked.add(uid);
    }
  }

  unblockUser(String uid) {
    if (blocked.contains(uid)) {
      blocked.remove(uid);
    }
  }

  blockedByMe(String uid) {
    blockedBy.add(uid);
  }

  unblockedByMe(String uid) {
    blockedBy.remove(uid);
  }

  removeDp() {
    dp = '';
  }

  removeCp() {
    cp = '';
  }
}
