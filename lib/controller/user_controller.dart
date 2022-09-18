import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/api/api_services.dart';

import '../services/firebase/storage_service.dart';

class UserController with ChangeNotifier {
  final Logger _logger = Logger("UserController");
  final ApiServices _apiServices = ApiServices();
  ProfileStatus profileStatus = ProfileStatus.nil;
  UserUploadingImage userUploadingImage = UserUploadingImage.notLoading;
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
}
