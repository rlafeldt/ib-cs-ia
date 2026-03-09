// Importing required packages and screens
import 'package:app_cs/screens/auth/login_screen.dart';
import 'package:app_cs/services/auth/signup_email_password_failure.dart';
import 'package:flutter/material.dart';
import 'package:app_cs/screens/home_screen_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// Class to encapsulate authentication methods
class AuthMethods {
  // Constructor accepting a FirebaseAuth instance
  const AuthMethods(this._auth);

  // FirebaseAuth instance for authentication tasks
  final FirebaseAuth _auth;

  // Stream to monitor authentication state changes (login/logout)
  Stream<User?> get authStateChange => _auth.idTokenChanges();

  // Method to fetch the current user's UID
  String fetchUserId() {
    return _auth.currentUser!.uid;
  }

  // Method to fetch the current authenticated user
  User? fetchCurrentUser() {
    return _auth.currentUser;
  }

  // Method to initiate password reset flow
  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      // Sending password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      // Closing any open snackbars and showing success message
      Get.closeAllSnackbars();
      Get.snackbar("Success", "Check your email to reset your password.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
      // Navigating to the login screen post-success
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (error) {
      // Handling errors and displaying in snackbars
      Get.closeAllSnackbars();
      Get.snackbar("Error",
          error.message == null ? "${error.message}" : 'Password reset failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
    }
  }

  // Method to sign in user with email and password
  Future<User> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      // Attempting to sign in
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Extracting User from the result
      final User firebaseUser = result.user!;
      // Navigating to the user home screen on success
      Get.offAll(() => const UserMobileHomeScreen());
      return firebaseUser;
    } on FirebaseAuthException catch (error) {
      // Handling authentication errors
      var ex = SignUpWithEmailPasswordFailure.code(error.code).message;
      Get.closeAllSnackbars();
      Get.snackbar("Error",
          error.message != null ? "${error.message}" : 'Authentication failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      // Throwing custom exception for error handling
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailPasswordFailure();
      // Throwing custom exception for unexpected errors
      throw ex;
    }
  }

  // Method to create a new user account with email and password
  Future<User> createUserWithEmailAndPassword(String email, String password,
      String firstName, String lastName, BuildContext context) async {
    try {
      // Creating a new user account
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User user = userCredential.user!;
      // Navigating to the user home screen on account creation
      Get.offAll(() => const UserMobileHomeScreen());
      return user;
    } on FirebaseAuthException catch (error) {
      // Handling authentication errors
      final ex = SignUpWithEmailPasswordFailure.code(error.code);
      Get.closeAllSnackbars();
      Get.snackbar("Error",
          error.message != null ? "${error.message}" : 'Authentication failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      // Throwing custom exception for error handling
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailPasswordFailure();
      // Throwing custom exception for unexpected errors
      throw ex;
    }
  }

  // Method to sign out the current user
  Future<void> signOut(BuildContext context) async {
    try {
      // Attempting to sign out the user
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      // Handling sign out errors
      final ex = SignUpWithEmailPasswordFailure.code(error.code);
      Get.closeAllSnackbars();
      Get.snackbar("Error", error.message != null ? "$ex" : 'Signout failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
    } catch (_) {
      const ex = SignUpWithEmailPasswordFailure();
      // Throwing custom exception for unexpected errors
      throw ex;
    }
  }
}
