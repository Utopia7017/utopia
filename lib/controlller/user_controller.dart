import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:utopia/enums/enums.dart';
import 'package:utopia/models/user_model.dart';
import 'package:utopia/services/api/api_services.dart';

class UserController with ChangeNotifier {
  final Logger _logger = Logger("UserController");
  final ApiServices _apiServices = ApiServices();
  ProfileStatus profileStatus = ProfileStatus.nil;
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
}
