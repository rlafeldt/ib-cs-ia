import 'package:app_cs/models/user.dart';

import 'package:app_cs/services/controllers/user_repository.dart';

import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final _userRepo = Get.put(UserRepository());

  Future<UserModel> getUserData(String email) {
    if (email != null) {
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to continue");
      return Future.error("Login to continue");
    }
  }

  Future<List<UserModel>> getAllUser() async {
    return await _userRepo.getAllUser();
  }
}
