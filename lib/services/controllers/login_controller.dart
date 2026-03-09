import 'package:app_cs/models/user.dart';

import 'package:app_cs/services/providers/auth_provider.dart';
import 'package:app_cs/services/controllers/user_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class LogInController extends GetxController {
  static LogInController instance = Get.find();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final userRepo = Get.put(UserRepository());

  Future<void> logInUser(String email, String password, WidgetRef ref,
      BuildContext context) async {
    await ref
        .watch(authProvider)
        .signInWithEmailAndPassword(email, password, context);
    emailController.clear();
    passwordController.clear();
  }

  Future<UserModel> fetchUser(String email, Ref ref) async {
    final user = await userRepo.getUserDetails(email);
    return user;
  }
}
