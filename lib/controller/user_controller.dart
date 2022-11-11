import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:logging/logging.dart';
import 'package:utopia/controller/disposable_controller.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/api/api_services.dart';
import 'package:utopia/services/firebase/notification_service.dart';
import '../services/firebase/storage_service.dart';

class UserController extends DisposableProvider {
  final Logger _logger = Logger("UserController");
  final ApiServices _apiServices = ApiServices();
  ProfileStatus profileStatus = ProfileStatus.nil;
  UserUploadingImage userUploadingImage = UserUploadingImage.notLoading;
  FollowingUserStatus followingUserStatus = FollowingUserStatus.no;
  User? user;

  // set current user
  setUser(String userId) async {
    profileStatus = ProfileStatus.loading;
    final endUrl = 'users/$userId.json';
    try {
      final Response? response = await _apiServices.get(endUrl: endUrl);
      if (response != null) {
        user = User.fromJson(response.data);
      }
    } catch (error) {
      _logger.shout(error.toString());
    }
    profileStatus = ProfileStatus.fetched;
    notifyListeners();
  }

  // call this method and provide an user object to create a new user
  createUser(User newUser) async {
    try {
      final Response? response = await _apiServices.put(
          endUrl: 'users/${newUser.userId}.json', data: newUser.toJson());
      if (response != null) {
        user = newUser;
      }
    } catch (error) {
      _logger.shout(error.toString());
    }
    profileStatus = ProfileStatus.fetched;
    notifyListeners();
  }

  // This method returns an User object.
  Future<User?> getUser(String uid) async {
    Logger logger = Logger("GetUser");
    try {
      final response = await _apiServices.get(endUrl: 'users/$uid.json');
      if (response != null) {
        return User.fromJson(response.data);
      }
    } catch (error) {
      return null;
    }
    return null;
  }

  // Change cover picture , user needs to pass an XFile
  void changeCoverPhoto(CroppedFile imageFile) async {
    Logger logger = Logger("ChangeCP");
    try {
      userUploadingImage = UserUploadingImage.loading;
      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();
      String? url = await getImageUrl(
          File(imageFile.path), 'users/${user!.userId}/coverphoto/cp');
      await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {'cp': url!});
      user!.changeCoverPhoto(url);
      logger.info(url);
    } catch (error) {
      return null;
    }
    userUploadingImage = UserUploadingImage.notLoading;
    notifyListeners();
  }

  // Change display picture , user needs to pass an XFile
  void changeDisplayPhoto(CroppedFile imageFile) async {
    Logger logger = Logger("ChangeDP");
    try {
      userUploadingImage = UserUploadingImage.loading;
      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();
      String? url = await getImageUrl(
          File(imageFile.path), 'users/${user!.userId}/displayphoto/dp');
      await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {'dp': url!});
      user!.changeDisplayPicture(url);
      logger.info(url);
    } catch (error) {
      return null;
    }
    userUploadingImage = UserUploadingImage.notLoading;
    notifyListeners();
  }

  // By calling this method currently signed in user can follow the user with the provided userd id.
  void followUser({required userId}) async {
    Logger logger = Logger("FollowAuthor");
    followingUserStatus = FollowingUserStatus.yes;
    await Future.delayed(const Duration(microseconds: 1));
    notifyListeners();
    try {
      User? userToFollow = await getUser(userId); // get user by user id
      if (userToFollow != null) {
        List<dynamic> followers =
            userToFollow.followers; // get their followers.
        followers.add(user!.userId); // increase their followers locally.
        // update their profile to the server.
        await _apiServices.update(
            endUrl: 'users/$userId.json', data: {'followers': followers});
        // update currently signed in user's profile (increase following list first)
        List<dynamic> myFollowings = user!.following;
        // increase my following locally.
        myFollowings.add(userId);
        // update following list to my profile (server)
        await _apiServices.update(
            endUrl: 'users/${user!.userId}.json',
            data: {'following': myFollowings});
        user!.following = myFollowings;
        notifyUserWhenFollowedUser(user!.userId, userId);
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    followingUserStatus = FollowingUserStatus.no;
    notifyListeners();
  }

  removeFollower(String followerId, String myUid) async {
    followingUserStatus = FollowingUserStatus.yes;
    await Future.delayed(const Duration(microseconds: 1));
    notifyListeners();
    try {
      User? userToRemoveFromFollowers =
          await getUser(followerId); // get user by user id
      if (userToRemoveFromFollowers != null) {
        List<dynamic> following =
            userToRemoveFromFollowers.following; // get their following
        following
            .remove(myUid); // remove my user id from their followers locally.
        // update their profile to the server.
        await _apiServices.update(
            endUrl: 'users/$followerId.json', data: {'following': following});
        // update currently signed in user's profile (increase following list first)
        List<dynamic> myFollowers = user!.followers;
        // increase my following locally.
        myFollowers.remove(followerId);
        // update following list to my profile (server)
        await _apiServices.update(
            endUrl: 'users/${user!.userId}.json',
            data: {'followers': myFollowers});
        user!.followers = myFollowers;
      }
    } catch (error) {
      rethrow;
    }
    followingUserStatus = FollowingUserStatus.no;
    notifyListeners();
  }

  // By calling this method currently signed in user can unfollow the user with the passed user id.
  void unFollowUser({required String userId}) async {
    followingUserStatus = FollowingUserStatus.yes;
    await Future.delayed(const Duration(microseconds: 1));
    notifyListeners();
    try {
      User? userToFollow = await getUser(userId); // get user by user id
      if (userToFollow != null) {
        List<dynamic> followers =
            userToFollow.followers; // get their followers.
        followers.remove(user!.userId); // increase their followers locally.
        // update their profile to the server.
        await _apiServices.update(
            endUrl: 'users/$userId.json', data: {'followers': followers});
        // update currently signed in user's profile (increase following list first)
        List<dynamic> myFollowings = user!.following;
        // increase my following locally.
        myFollowings.remove(userId);
        // update following list to my profile (server)
        await _apiServices.update(
            endUrl: 'users/${user!.userId}.json',
            data: {'following': myFollowings});
        user!.following = myFollowings;
      }
    } catch (error) {
      rethrow;
    }
    followingUserStatus = FollowingUserStatus.no;
    notifyListeners();
  }

  // Update profile -> username and bio
  updateProfile({required String name, required String bio}) async {
    Logger logger = Logger("UserController-updateProfile");
    try {
      final Response? profileUpdateResponse = await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {
        'name': name,
        'bio': bio,
      });
      if (profileUpdateResponse != null) {
        user!.updateProfile(name, bio);
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    notifyListeners();
  }

  // Saves article id and article author id to the list
  saveArticle({required String authorId, required String articleId}) async {
    Logger logger = Logger("saveArticle");
    dynamic savedArticle = {'authorId': authorId, 'articleId': articleId};
    List<dynamic> savedArticleList = user!.savedArticles;
    savedArticleList.add(savedArticle);
    try {
      final Response? response = await _apiServices.update(
          endUrl: 'users/${user!.userId}.json',
          data: {'savedArticles': savedArticleList});
      if (response != null) {
        user!.updateSavedArticleList(savedArticleList);
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    notifyListeners();
  }

  // Unsave the article
  unSaveArticle({required String authorId, required String articleId}) async {
    Logger logger = Logger("unSaveArticle");

    List<dynamic> savedArticleList = user!.savedArticles;
    int indexTobeRemoved = savedArticleList.indexWhere((element) =>
        (element['articleId'] == articleId && element['authorId'] == authorId));

    savedArticleList.removeAt(indexTobeRemoved);
    try {
      final Response? response = await _apiServices.update(
          endUrl: 'users/${user!.userId}.json',
          data: {'savedArticles': savedArticleList});
      if (response != null) {
        user!.updateSavedArticleList(savedArticleList);
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    notifyListeners();
  }

  // method to unblock user ( user id of the persopn is required )
  blockThisUser(String uid) async {
    Logger logger = Logger("Block This User");
    try {
      if (!user!.blocked.contains(uid)) {
        List<dynamic> currentBlockedUsers = user!.blocked;
        currentBlockedUsers.add(uid);
        final Response? response = await _apiServices.update(
            message: "Blocked",
            showMessage: false,
            endUrl: 'users/${user!.userId}.json',
            data: {'blocked': currentBlockedUsers});
        if (response != null) {
          user!.blockUser(uid);
        }
        User? thatUser = await getUser(uid);
        List<dynamic> currentBlockedByList = thatUser!.blockedBy;
        currentBlockedByList.add(user!.userId);
        final Response? thatUserResponse = await _apiServices.update(
            endUrl: 'users/$uid.json',
            data: {'blockedBy': currentBlockedByList});
        if (thatUserResponse != null) {
          thatUser.blockedByMe(user!.userId);
          if (thatUser.following.contains(user!.userId)) {
            await removeFollower(uid, user!.userId);
            
          }
        }
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    notifyListeners();
  }

  // method to unblock user ( user id of the persopn is required )
  unBlockThisUser(String uid) async {
    Logger logger = Logger("Unblock This User");
    try {
      if (user!.blocked.contains(uid)) {
        List<dynamic> currentBlockedUsers = user!.blocked;
        currentBlockedUsers.remove(uid);
        final Response? response = await _apiServices.update(
            message: "Unblocked",
            showMessage: false,
            endUrl: 'users/${user!.userId}.json',
            data: {'blocked': currentBlockedUsers});
        if (response != null) {
          user!.unblockUser(uid);
        }
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    notifyListeners();
  }

  void removeDp() async {
    try {
      final Response? response = await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {'dp': ''});
      if (response != null) {
        user!.removeDp();
      }
    } catch (errror) {
      print(errror);
    }
    notifyListeners();
  }

  void removeCp() async {
    try {
      final Response? response = await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {'cp': ''});
      if (response != null) {
        user!.removeCp();
      }
    } catch (errror) {
      print(errror);
    }
    notifyListeners();
  }

  // Dispose this provider
  @override
  void disposeValues() {
    profileStatus = ProfileStatus.nil;
    userUploadingImage = UserUploadingImage.notLoading;
    followingUserStatus = FollowingUserStatus.no;
    user = null;
  }
}
