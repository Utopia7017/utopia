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

class UserSate {
  // class menmbers
  final ApiServices _apiServices = ApiServices();
  ProfileStatus profileStatus = ProfileStatus.nil;
  FetchingPopularAuthors fetchingPopularAuthors = FetchingPopularAuthors.nil;
  UserUploadingImage userUploadingImage = UserUploadingImage.notLoading;
  FollowingUserStatus followingUserStatus = FollowingUserStatus.no;
  List<User>? popularAuthors = [];
  User? user;

  // Constructor
  UserSate({this.user, this.popularAuthors});

  // call this method to update the state from within the class
  UserSate _updateState({User? user, List<User>? popularAuthors}) {
    return UserSate(
        popularAuthors: popularAuthors ?? this.popularAuthors,
        user: user ?? this.user);
  }

  // Get the list of popular authors
  Future<UserSate> getPopularAuthors() async {
    fetchingPopularAuthors = FetchingPopularAuthors.fetching;
    await Future.delayed(const Duration(milliseconds: 1));
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
      print(e.toString());
    }
    popularAuthors = temp;
    fetchingPopularAuthors = FetchingPopularAuthors.fetched;
    return _updateState(popularAuthors: popularAuthors);
  }

  // Set current user
  /// Returning a future of type UserState.
  Future<UserSate> setUser(String userId) async {
    profileStatus = ProfileStatus.loading;
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
    profileStatus = ProfileStatus.fetched;
    return _updateState(user: currentUser);
  }

  // Creates a new user
  Future<UserSate> createUser(User newUser) async {
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
    profileStatus = ProfileStatus.fetched;
    return _updateState(user: currUser);
  }

  /// It changes the cover photo of the user.
  ///
  /// Args:
  ///   imageFile (CroppedFile): The image file that you want to upload.
  Future<UserSate> changeCoverPhoto(CroppedFile imageFile) async {
    try {
      userUploadingImage = UserUploadingImage.loading;
      await Future.delayed(const Duration(milliseconds: 1));

      String? url = await getImageUrl(
          File(imageFile.path), 'users/${user!.userId}/coverphoto/cp');
      await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {'cp': url!});
      user!.changeCoverPhoto(url);
    } catch (error) {
      debugPrint(error.toString());
    }
    userUploadingImage = UserUploadingImage.notLoading;
    return _updateState(user: user);
  }

  /// It changes the display photo of the user.
  ///
  /// Args:
  ///   imageFile (CroppedFile): The cropped image file that you want to upload as your display photo.
  Future<UserSate> changeDisplayPhoto(CroppedFile imageFile) async {
    try {
      userUploadingImage = UserUploadingImage.loading;
      await Future.delayed(const Duration(milliseconds: 1));

      String? url = await getImageUrl(
          File(imageFile.path), 'users/${user!.userId}/displayphoto/dp');
      await _apiServices
          .update(endUrl: 'users/${user!.userId}.json', data: {'dp': url!});
      user!.changeDisplayPicture(url);
    } catch (error) {
      debugPrint(error.toString());
    }
    userUploadingImage = UserUploadingImage.notLoading;
    return _updateState(user: user);
  }

  /// It removes a follower from the user's list of followers.
  ///
  /// Args:
  ///   followerId (String): The id of the user who is following you.
  ///   myUid (String): The user's uid
  Future<UserSate> removeFollower(String followerId, String myUid) async {
    followingUserStatus = FollowingUserStatus.yes;
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
    followingUserStatus = FollowingUserStatus.no;
    return _updateState(user: user);
  }

  /// It follows a user.
  ///
  /// Args:
  ///   userId: The user id of the user you want to follow.
  Future<UserSate> followUser({required userId}) async {
    followingUserStatus = FollowingUserStatus.yes;

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
    followingUserStatus = FollowingUserStatus.no;
    return _updateState(popularAuthors: popularAuthors, user: user);
  }

  /// It updates the user's profile
  ///
  /// Args:
  ///   name (String): The name of the user.
  ///   bio (String): The user's bio.
  ///
  /// Returns:
  ///   The user's state.
  Future<UserSate> updateProfile(
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
  Future<UserSate> saveArticle(
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
  Future<UserSate> unSaveArticle(
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
  Future<UserSate> blockThisUser(String uid) async {
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
  Future<UserSate> unBlockThisUser(String uid) async {
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

  Future<UserSate> removeDp() async {
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

  Future<UserSate> removeCp() async {
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
