import 'package:app_cs/models/claim.dart';

import 'package:app_cs/services/controllers/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClaimController extends GetxController {
  static ClaimController instance =
      Get.find(); // Singleton instance of ClaimController for global access
  RxBool restored = false.obs; // Reactive boolean to track restoration state

  final _db =
      FirebaseFirestore.instance; // Firestore instance for database operations

  // TextEditingControllers for managing text input fields in the UI
  final processNumber = TextEditingController();
  final amount = TextEditingController();
  final endDate = TextEditingController();
  final startDate = TextEditingController();
  final rate = TextEditingController();
  final fees = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final baseDate = TextEditingController();
  final amountPaid = TextEditingController();

  final userRepo = Get.put(
      UserRepository()); // Injecting UserRepository for user-related operations

// Default claim object for initialization
  Claim claim = Claim(
    "",
    0.0,
    0.0,
    "",
    "",
    0.0,
    "",
    true,
    "",
    "",
    "",
    0.0,
    0.0,
    0.0,
  );

// Function to create a new claim in Firestore
  Future<void> createClaim(Claim claim) async {
    await _db
        .collection("claims") // Accessing 'claims' collection in Firestore
        .doc(processNumber.text) // Setting document ID to the process number
        .set(claim
            .toJson()) // Converting claim object to JSON and storing in Firestore
        .whenComplete(() {
      // Clearing all input fields after successful creation
      processNumber.clear();
      amount.clear();
      endDate.clear();
      startDate.clear();
      rate.clear();
      fees.clear();
      firstName.clear();
      lastName.clear();
      baseDate.clear();
      amountPaid.clear();

      Get.closeAllSnackbars();
      Get.snackbar("Success",
          "Your claim has been created", // Displaying success message
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    }).catchError((error, stackTrace) {
      // Handling errors and displaying an error message
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }

  // Function to retrieve claim data based on processID
  Future<Claim> getClaimData(String processID) async {
    if (processID != null) {
      //Accesses the claims collection in the database referenced by _db.
      //_db variable is an instance of FirebaseFirestore, which allows the interaction with my database.
      final snapshot = await _db
          .collection("claims")
          //This is where the function specifies the query conditions.
          //The .where method filters documents in the claims collection.
          //The function looks for documents where the processID field is equal to the processID parameter provided to the function.
          .where("processID", isEqualTo: processID)
          //.get() method is called to execute the query and fetch the results from the database.
          //Since this operation is asynchronous, it is awaited using the await keyword. The result is stored in the snapshot variable.
          .get();

      final claimData = snapshot.docs.map((e) {
        var claimSingle = Claim.create();
        claimSingle = claimSingle.fromSnapshot(
            e); //build claim object from claim document map from database
        return claimSingle; //return claim object
      }).single; //ensures that only one element is returned
      return claimData;
    } else {
      //If not found, return an error message
      Get.snackbar("Error", "No Claim found");
      return Future.error("No Claim found");
    }
  }

// Function to retrieve all claim records
  Future<List<Claim>> getAllClaims() async {
    // Attempt to get the collection of documents from Firestore.
    // The documents are ordered by the 'timestamp' field in descending order,
    // meaning the most recent claims will come first.
    try {
      final snapshot = await _db
          .collection("calculatedClaims")
          .orderBy('timestamp', descending: true)
          .get();

      // Map each document snapshot to a Claim object. This involves:
      // 1. Creating a new Claim instance using a factory method or constructor named `create`.
      // 2. Populating the Claim object with data from the document snapshot using a method like `fromSnapshot`.
      final claimData = snapshot.docs.map((e) {
        var claim = Claim.create();
        claim = claim.fromSnapshot(e);
        return claim;
      }).toList();
      // Return the list of Claim objects populated with data from Firestore.
      return claimData;
    } catch (error) {
      // If an error occurs return an empty list.
      return [];
    }
  }

  // Function to fetch the most recent claim records, limited to a specific number (3)
  Future<List<Claim>> fetchRecentClaims() async {
    try {
      var snapshot = await _db
          .collection("calculatedClaims")
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get();

      final claimData = snapshot.docs.map((e) {
        var claim1 = Claim.create();
        return claim1.fromSnapshot(e);
      }).toList();
      return claimData;
    } catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }

// Function to update an existing claim record
  Future<void> updateClaim(Claim claim, String processID) async {
    await _db
        .collection("claims")
        .doc(processID)
        .delete()
        .whenComplete(() async {
      //updating both in claims and calculated claims

      // update works by deleting previous claim and creating record for new claim
      await _db.collection("calculatedClaims").doc(processID).delete();
      await _db.collection("claims").doc(claim.processID).set(claim.toJson());
      //claim will automatically be added to calculated claims because of cloud function
    }).whenComplete(() {
      Get.snackbar("Success", "Your claim has been updated",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      print("UPDATE CLAIM ERROR ${error.toString()}");
    });
  }

  // Function to delete a claim record
  Future<void> deleteClaim(Claim claim, BuildContext context) async {
    await _db
        .collection("claims")
        .doc(claim.processID)
        .delete()
        .whenComplete(() async {
      await _db.collection("calculatedClaims").doc(claim.processID).delete();
    }).whenComplete(() {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text(
            "Claim deleted",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.5),
          action: SnackBarAction(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            label: "Undo",
            onPressed: () {
              restoreClaim(claim);
            },
          ),
        ),
      );
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      print("DELETE CLAIM ERROR: {error.toString()}");
    });
  }

  // Function to restore a deleted claim record
  restoreClaim(Claim claim) async {
    await _db
        .collection("claims")
        .doc(claim.processID)
        .set(claim.toJson())
        .whenComplete(() async {
      await _db
          .collection("calculatedClaims")
          .doc(claim.processID)
          .set(claim.toJson());
    }).whenComplete(() {
      update();
      Get.closeAllSnackbars();
      Get.snackbar("Success", "Claim Restored",
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
