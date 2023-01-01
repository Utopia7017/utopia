import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/api/api_services.dart';
import 'package:utopia/services/firebase/notification_service.dart';
import 'package:utopia/services/firebase/storage_service.dart';
import '../utils/common_api_calls.dart';

class UserState {
  // class menmbers
  final ApiServices _apiServices = ApiServices();
  ProfileStatus profileStatus = ProfileStatus.NOT_FETCHED;
  FetchingPopularAuthors fetchingPopularAuthors =
      FetchingPopularAuthors.NOT_FETCHED;
  UserUploadingImage userUploadingImage = UserUploadingImage.NOT_LOADING;
  FollowingUserStatus followingUserStatus = FollowingUserStatus.NO;
  List<User>? popularAuthors = [];
  User? user;

  /// A constructor for the UserState class.
  UserState({
    required this.user,
    required this.popularAuthors,
    required this.fetchingPopularAuthors,
    required this.followingUserStatus,
    required this.profileStatus,
    required this.userUploadingImage,
  });

  /// A factory constructor that returns a UserState object.
  ///
  /// Returns:
  ///   A UserState object with all of its properties set to their default values.
  factory UserState.initUserState() {
    return UserState(
        user: null,
        popularAuthors: [],
        fetchingPopularAuthors: FetchingPopularAuthors.NOT_FETCHED,
        followingUserStatus: FollowingUserStatus.NO,
        profileStatus: ProfileStatus.NOT_FETCHED,
        userUploadingImage: UserUploadingImage.NOT_LOADING);
  }

  // call this method to update the state from within the class
  UserState _updateState(
      {User? user,
      List<User>? popularAuthors,
      FetchingPopularAuthors? fetchingPopularAuthors,
      FollowingUserStatus? followingUserStatus,
      ProfileStatus? profileStatus,
      UserUploadingImage? userUploadingImage}) {
    return UserState(
      popularAuthors: popularAuthors ?? this.popularAuthors,
      user: user ?? this.user,
      fetchingPopularAuthors:
          fetchingPopularAuthors ?? this.fetchingPopularAuthors,
      followingUserStatus: followingUserStatus ?? this.followingUserStatus,
      profileStatus: profileStatus ?? this.profileStatus,
      userUploadingImage: userUploadingImage ?? this.userUploadingImage,
    );
  }

  /// > This function returns a new UserState object with the fetchingPopularAuthors property set to
  /// FETCHING
  ///
  /// Returns:
  ///   A new instance of the UserState class.
  UserState startFetchingPopularAuthors() {
    return _updateState(
        fetchingPopularAuthors: FetchingPopularAuthors.FETCHING);
  }

  /// If the user is currently fetching popular authors, stop fetching them.
  ///
  /// Returns:
  ///   A new UserState object with the fetchingPopularAuthors property set to FETCHED.
  UserState stopFetchingPopularAuthors() {
    return _updateState(fetchingPopularAuthors: FetchingPopularAuthors.FETCHED);
  }

  /// If the user is not already following the user, then start following the user.
  ///
  /// Returns:
  ///   A new instance of the UserState class with the followingUserStatus property set to YES.
  UserState startFollowingUser() {
    return _updateState(followingUserStatus: FollowingUserStatus.YES);
  }

  /// If the user is following the user, stop following the user.
  ///
  /// Returns:
  ///   A new UserState object with the followingUserStatus set to FollowingUserStatus.NO
  UserState stopFollowingUser() {
    return _updateState(followingUserStatus: FollowingUserStatus.NO);
  }

  /// It returns a new UserState object with the profileStatus set to FETCHING.
  ///
  /// Returns:
  ///   A new UserState object with the profileStatus set to FETCHING.
  UserState startFetchingMyProfile() {
    return _updateState(profileStatus: ProfileStatus.FETCHING);
  }

  /// It returns a new UserState object with the profileStatus set to ProfileStatus.FETCHED.
  ///
  /// Returns:
  ///   A new instance of the UserState class.
  UserState stopFetchingMyProfile() {
    return _updateState(profileStatus: ProfileStatus.FETCHED);
  }

  /// It returns a new UserState object with the userUploadingImage property set to
  /// UserUploadingImage.LOADING.
  ///
  /// Returns:
  ///   A new instance of the UserState class with the userUploadingImage property set to
  /// UserUploadingImage.LOADING.
  UserState startUploadingImage() {
    return _updateState(userUploadingImage: UserUploadingImage.LOADING);

    /// "When the user clicks the button, we want to start fetching the popular authors."
    ///
    /// The first thing we do is call the `startFetchingPopularAuthors` function on the `userState`. This
    /// function returns a new `UserState` object with the `isFetchingPopularAuthors` property set to
    /// `true`
  }

  /// It returns a new UserState object with the userUploadingImage property set to NOT_LOADING.
  ///
  /// Returns:
  ///   A new instance of the UserState class with the userUploadingImage property set to
  /// UserUploadingImage.NOT_LOADING.
  UserState stopUploadingImage() {
    /// "When the user clicks the follow button, we want to start following the user."
    ///
    /// The first thing we do is call the `startFollowingUser` function on the `userState` object. This
    /// function returns a new `UserState` object with the `isFollowing` property set to `true`
    return _updateState(userUploadingImage: UserUploadingImage.NOT_LOADING);
  }

  /// It fetches the popular authors from the server and stores them in the popularAuthors list.
  ///
  /// Returns:
  ///   A Future<UserState>
  Future<UserState> getPopularAuthors() async {
    // start fetching popular authors
    List<User> temp = [];
    try {
      final Response? response = await _apiServices.get(endUrl: 'users.json');
      if (response != null) {
        var data = response.data as Map<String, dynamic>;
        for (var userData in data.values) {
          User thisUser = User.fromJson(userData);
          if (user!.userId != thisUser.userId &&
              !user!.following.contains(thisUser.userId)) {
            temp.add(thisUser);
          }
        }
        temp.sort(
          (a, b) {
            return a.isVerified && a.followers.length > b.followers.length
                ? 0
                : 1;
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    popularAuthors = temp;
    // stop fetching popular authors
    return _updateState(popularAuthors: popularAuthors);
  }

  // Set current user
  /// Returning a future of type UserState.
  Future<UserState> setUser(String userId) async {
    // start fecthing profile
    User? currentUser;
    final endUrl = 'users/$userId.json';
    try {
      final Response? response = await _apiServices.get(endUrl: endUrl);
      if (response != null) {
        currentUser = User.fromJson(response.data);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    // stop fetching profile
    return _updateState(user: currentUser);
  }

  /// It creates a new user in the database.
  ///
  /// Args:
  ///   newUser (User): The user object that we want to create.
  ///
  /// Returns:
  ///   A Future<UserState>
  Future<UserState> createUser(User newUser) async {
    User? currUser;
    try {
      final Response? response = await _apiServices.put(
          endUrl: 'users/${newUser.userId}.json', data: newUser.toJson());
      if (response != null) {
        currUser = newUser;
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    // stop fetching profile
    return _updateState(user: currUser);
  }

  /// It takes a cropped image file, uploads it to firebase storage, gets the image url, updates the
  /// user's cover photo url in the database, and updates the user's cover photo url in the user object
  ///
  /// Args:
  ///   imageFile (CroppedFile): The image file that you want to upload.
  ///
  /// Returns:
  ///   A Future<UserState>
  Future<UserState> changeCoverPhoto(CroppedFile imageFile) async {
    try {
      // userUploadingImage = UserUploadingImage.loading;
      // start uploading image
      await Future.delayed(const Duration(milliseconds: 1));

      /// It saves an article to the user's saved articles list.
      ///
      /// Args:
      ///   authorId (String): The author's id
      ///   articleId (String): The id of the article to be saved.

      String? url = await getImageUrl(
          File(imageFile.path), 'users/${user!.userId}/coverphoto/cp');
      await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {'cp': url!});
      user!.changeCoverPhoto(url);
    } catch (error) {
      debugPrint(error.toString());
    }
    // userUploadingImage = UserUploadingImage.notLoading;
    // stop uploading image
    return _updateState(user: user);
  }

  /// It takes a cropped image file, uploads it to firebase storage, gets the image url, updates the
  /// user's display picture url in the database and updates the user object in the state
  ///
  /// Args:
  ///   imageFile (CroppedFile): The image file to be uploaded.
  ///
  /// Returns:
  ///   A Future<UserState>
  Future<UserState> changeDisplayPhoto(CroppedFile imageFile) async {
    try {
      // userUploadingImage = UserUploadingImage.loading;
      // start uploading image
      await Future.delayed(const Duration(milliseconds: 1));

      String? url = await getImageUrl(
          File(imageFile.path), 'users/${user!.userId}/displayphoto/dp');
      await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {'dp': url!});
      user!.changeDisplayPicture(url);
    } catch (error) {
      debugPrint(error.toString());
    }
    // userUploadingImage = UserUploadingImage.notLoading;
    return _updateState(user: user);
  }

  /// > This function removes a user from the currently signed in user's followers list
  ///
  /// Args:
  ///   followerId (String): The user id of the user you want to remove from your followers list.
  ///   myUid (String): The user id of the currently signed in user.
  ///
  /// Returns:
  ///   A Future<UserState>
  Future<UserState> removeFollower(String followerId, String myUid) async {
    // followingUserStatus = FollowingUserStatus.yes;
    await Future.delayed(const Duration(microseconds: 1));
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
    // followingUserStatus = FollowingUserStatus.no;
    return _updateState(user: user);
  }

  /// It follows a user.
  ///
  /// Args:
  ///   userId: The user id of the user to be followed.
  ///
  /// Returns:
  ///   A Future<UserState>
  Future<UserState> followUser({required userId}) async {
    // followingUserStatus = FollowingUserStatus.yes;

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
        popularAuthors!.removeWhere(
          (element) => element.userId == userId,
        );
        notifyUserWhenFollowedUser(user!.userId, userId);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    // followingUserStatus = FollowingUserStatus.no;
    return _updateState(popularAuthors: popularAuthors, user: user);
  }

  /// > It removes the user id of the currently signed in user from the followers list of the user to be
  /// followed and also removes the user id of the user to be followed from the following list of the
  /// currently signed in user
  /// 
  /// Args:
  ///   userId (String): The user id of the user you want to follow.
  /// 
  /// Returns:
  ///   A Future<UserState>
  Future<UserState> unFollowUser({required String userId}) async {
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
    return getPopularAuthors();
  }

  /// It updates the user's profile
  ///
  /// Args:
  ///   name (String): The name of the user.
  ///   bio (String): The user's bio.
  ///
  /// Returns:
  ///   The user's state.
  Future<UserState> updateProfile(
      {required String name, required String bio}) async {
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
      debugPrint(error.toString());
    }
    return _updateState(user: user);
  }

  /// It takes in an authorId and an articleId, creates a map with those values, adds that map to the
  /// savedArticles list, and then updates the user's savedArticles list in the database
  ///
  /// Args:
  ///   authorId (String): The id of the author of the article.
  ///   articleId (String): The id of the article to be saved.
  ///
  /// Returns:
  ///   A Future<UserState>
  Future<UserState> saveArticleDetail(
      {required String authorId, required String articleId}) async {
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
      debugPrint(error.toString());
    }
    return _updateState(user: user);
  }

  /// It removes the article from the user's saved article list and updates the user's state
  ///
  /// Args:
  ///   authorId (String): The id of the author of the article.
  ///   articleId (String): The id of the article to be saved.
  ///
  /// Returns:
  ///   A Future<UserState>
  Future<UserState> unSaveArticleDetail(
      {required String authorId, required String articleId}) async {
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
      debugPrint(error.toString());
    }

    return _updateState(user: user);
  }

  /// It takes a user id as a parameter, checks if the current user has blocked that user, if not, it
  /// adds the user id to the current user's blocked list, updates the current user's blocked list in
  /// the database, gets the user that was blocked, adds the current user's id to the blocked by list of
  /// the user that was blocked, updates the blocked by list of the user that was blocked in the
  /// database, checks if the user that was blocked is following the current user, if so, it removes the
  /// user that was blocked from the current user's followers list, updates the current user's followers
  /// list in the database, and returns the current user's state
  ///
  /// Args:
  ///   uid (String): The user id of the user you want to block
  ///
  /// Returns:
  ///   The user state
  Future<UserState> blockThisUser(String uid) async {
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
            // this will return the user state
            return await removeFollower(uid, user!.userId);
          }
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    // Unreachable statement
    return _updateState(user: user);
  }

  /// It removes the user's id from the blocked list of the current user
  ///
  /// Args:
  ///   uid (String): The user id of the user you want to unblock.
  ///
  /// Returns:
  ///   A Future<UserState>
  Future<UserState> unBlockThisUser(String uid) async {
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
      debugPrint(error.toString());
    }
    return _updateState(user: user);
  }

  Future<UserState> removeDp() async {
    try {
      final Response? response = await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {'dp': ''});
      if (response != null) {
        user!.removeDp();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return _updateState(user: user);
  }

  Future<UserState> removeCp() async {
    try {
      final Response? response = await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {'cp': ''});
      if (response != null) {
        user!.removeCp();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return _updateState(user: user);
  }
}
