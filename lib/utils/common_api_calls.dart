import 'package:utopia/services/api/api_services.dart';

import '../models/user_model.dart';

Future<User?> getUser(String uid) async {
  try {
    final response = await ApiServices().get(endUrl: 'users/$uid.json');
    if (response != null) {
      return User.fromJson(response.data);
    }
  } catch (error) {
    return null;
  }
  return null;
}
