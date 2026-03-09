import 'package:app_cs/models/user.dart';

import 'package:app_cs/services/providers/auth_provider.dart';
import 'package:app_cs/services/controllers/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController instance = Get.find();

  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();

  final userRepo = Get.put(UserRepository());

  Future<void> registerUser(String email, String password, WidgetRef ref,
      BuildContext context, String firstName, String lastName) async {
    await ref.watch(authProvider).createUserWithEmailAndPassword(
        email, password, firstName, lastName, context);

    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
  }

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
  }
}
