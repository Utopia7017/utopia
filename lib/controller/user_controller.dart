import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/saved_article_model.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/api/api_services.dart';

import '../services/firebase/storage_service.dart';

class UserController with ChangeNotifier {
  final Logger _logger = Logger("UserController");
  final ApiServices _apiServices = ApiServices();
  ProfileStatus profileStatus = ProfileStatus.nil;
  UserUploadingImage userUploadingImage = UserUploadingImage.notLoading;
  FollowingUserStatus followingUserStatus = FollowingUserStatus.no;
  User? user;

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

  // This method returns an User object , generally called inside future builder widget as its future.
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
  }

  // Change cover picture , user needs to pass an XFile
  void changeCoverPhoto(XFile imageFile) async {
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
  void changeDisplayPhoto(XFile imageFile) async {
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

  // By calling this method currently signed in user can follow the user with the passed userd id.
  void followUser({required userId}) async {
    Logger logger = Logger("FollowAuthor");
    followingUserStatus = FollowingUserStatus.yes;
    await Future.delayed(const Duration(milliseconds: 1));
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
      }
    } catch (error) {
      logger.shout(error.toString());
    }
    followingUserStatus = FollowingUserStatus.no;
    notifyListeners();
  }

  // By calling this method currently signed in user can unfollow the user with the passed user id.
  void unFollowUser({required userId}) async {
    Logger logger = Logger("FollowAuthor");
    followingUserStatus = FollowingUserStatus.yes;
    await Future.delayed(const Duration(milliseconds: 1));
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
      logger.shout(error.toString());
    }
    followingUserStatus = FollowingUserStatus.no;
    notifyListeners();
  }

  // Saves article id and article author id to the list
  saveArticle({required String authorId, required String articleId}) async {
    Logger logger = Logger("saveArticle");
    dynamic savedArticle = {'authorId':authorId,'articleId':articleId};
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
}
