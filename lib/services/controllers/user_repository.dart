import 'package:app_cs/models/user.dart';
import 'package:app_cs/screens/auth/signup_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';

import 'package:flutter/material.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _db
        .collection("users")
        .doc(user.email.toLowerCase())
        .set(user.toJson())
        .whenComplete(() {
      Get.closeAllSnackbars();
      Get.snackbar("Success", "Your account has been created",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    }).catchError((error, stackTrace) {
      Get.closeAllSnackbars();
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }

// Method to retrieve user details from Firestore based on email
  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("users").where("email", isEqualTo: email).get();

    final userData = snapshot.docs
        .map(
          (e) => UserModel.fromSnapshot(e),
        )
        .single;
    return userData;
  }

// Method to retrieve all users from the 'users' collection
  Future<List<UserModel>> getAllUser() async {
    final snapshot = await _db.collection("users").get();

    final userData = snapshot.docs
        .map(
          (e) => UserModel.fromSnapshot(e),
        )
        .toList();
    return userData;
  }

// Method to update a user's record in Firestore
  Future<void> updateUserRecord(UserModel user, String oldEmail) async {
    await _db.collection("users").doc(oldEmail).delete().whenComplete(() async {
      await _db.collection("users").doc(user.email).set(user.toJson());
    }).whenComplete(() {
      Get.closeAllSnackbars();
      Get.snackbar("Success", "Your account has been updated",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    }).catchError((error, stackTrace) {
      Get.closeAllSnackbars();
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }

  // Method to confirm account deletion with the user
  Future<void> confirmDeleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete your Account?'),
          content: const Text(
              '''Your account and data will be permanently deleted from our servers.

Confirm delete?'''),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      var loggedUser = FirebaseAuth.instance.currentUser!;
      Navigator.of(context).pop();
      Get.offAll(() => const SignUpScreen());
      await _db.collection("users").doc(loggedUser.email).delete();
      await loggedUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete(context);
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      print(e.toString());
    }
  }

// Method to re-authenticate the user before deletion if required by Firebase
  Future<void> _reauthenticateAndDelete(BuildContext context) async {
    var firebaseAuth = FirebaseAuth.instance;
    try {
      var providerData = firebaseAuth.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await firebaseAuth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      var loggedUser = FirebaseAuth.instance.currentUser!;
      Navigator.of(context).pop();
      Get.offAll(() => const SignUpScreen());
      await _db.collection("users").doc(loggedUser.email).delete();
      await firebaseAuth.currentUser?.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //! deleting and restoring users will only delete them from firestore, not firebase auth.
  //! To delete and restore in firebase auth I have to use cloud functions for which I must pay.
  //! To make this work i am using firebase admin sdk but it can be unsafe
  // Method to delete a user's Firestore document, not their Firebase Auth record
  Future<void> deleteUser(UserModel user, BuildContext context) async {
    // admin.auth().deleteUser

    await _db.collection("users").doc(user.email).delete().whenComplete(() {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text(
            "User deleted from firestore but not firebaseAuth",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.5),
          action: SnackBarAction(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            label: "Undo",
            onPressed: () {
              restoreUser(user);
            },
          ),
        ),
      );
    }).catchError((error, stackTrace) {
      Get.closeAllSnackbars();
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.2),
          colorText: Colors.red);
      print("DELETE USER ERROR: {error.toString()}");
    });
  }

// Method to restore a deleted user's Firestore document
  restoreUser(UserModel user) async {
    await _db
        .collection("users")
        .doc(user.email)
        .set(user.toJson())
        .whenComplete(() {
      Get.closeAllSnackbars();
      Get.snackbar("Success", "User Restored",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.2),
          colorText: Colors.green);
    }).catchError((error, stackTrace) {
      Get.closeAllSnackbars();
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.2),
          colorText: Colors.red);
      print(error.toString());
    });
  }
}
