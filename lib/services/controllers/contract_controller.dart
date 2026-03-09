import 'package:app_cs/models/contract.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Defining the ContractController class that extends GetxController for state management
class ContractController extends GetxController {
  // Singleton pattern to ensure only one instance is created
  static ContractController instance = Get.find();

  final _db = FirebaseFirestore
      .instance; // Firebase Firestore instance for database operations

// TextEditingControllers for managing text field inputs in the UI
  final cpf = TextEditingController();
  final rg = TextEditingController();
  final address = TextEditingController();
  final cep = TextEditingController();
  final originProcess = TextEditingController();
  final birthday = TextEditingController();
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

  // Function to create a new contract in the Firestore database
  Future<void> createContract(Contract contract) async {
    await _db
        .collection("contracts") // Accessing the 'contracts' collection
        .doc(processNumber.text) // Using process number as the document ID
        .set(contract
            .toJson()) // Converting the Contract object to JSON and setting it to the document
        .whenComplete(() {
      // Clearing the text fields after successful operation
      processNumber.clear();
      amount.clear();
      endDate.clear();
      startDate.clear();
      rate.clear();
      fees.clear();
      firstName.clear();
      lastName.clear();
      baseDate.clear();
      birthday.clear();
      cpf.clear();
      rg.clear();
      address.clear();
      cep.clear();
      originProcess.clear();
      amountPaid.clear();

      Get.snackbar("Success",
          "Your contract has been created", // Showing success message using GetX snackbar
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    }).catchError((error, stackTrace) {
      // Error handling
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }

// Function to retrieve contract data based on processID
  Future<Contract> getContractData(String processID) async {
    if (processID != null) {
      final snapshot = await _db
          .collection("contracts")
          .where("processID", isEqualTo: processID)
          .get();

      final contractData = snapshot.docs.map((e) {
        Contract contractSingle = Contract.fromSnapshot(e);

        return contractSingle;
      }).single;
      return contractData;
    } else {
      Get.snackbar("Error", "Login to continue");
      return Future.error("Login to continue");
    }
  }

// Function to retrieve all contracts from Firestore
  Future<List<Contract>> getAllContracts() async {
    final snapshot = await _db
        .collection("contracts")
        .orderBy('timestamp', descending: true)
        .get();
    final contractData = snapshot.docs.map((e) {
      Contract contract1 = Contract.fromSnapshot(e);

      return contract1;
    }).toList();
    return contractData;
  }

// Function to update an existing contract in Firestore
  Future<void> updateContract(Contract contract, String processID) async {
    await _db
        .collection("contracts")
        .doc(contract.processID)
        .update(contract.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "Your contract has been updated",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green),
        )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      print("UPDATE CONTRACT ERROR ${error.toString()}");
    });
  }

  // Function to delete a contract from Firestore
  Future<void> deleteContract(Contract contract, BuildContext context) async {
    await _db
        .collection("contracts")
        .doc(contract.processID)
        .delete()
        .whenComplete(() {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: const Text(
            "Contract deleted",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.5),
          action: SnackBarAction(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            label: "Undo",
            onPressed: () {
              restoreContract(contract);
            },
          ),
        ),
      );
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      print("DELETE CONTRACT ERROR: {error.toString()}");
    });
  }

  // Function to restore a deleted contract in Firestore
  restoreContract(Contract contract) async {
    await _db
        .collection("contracts")
        .doc(contract.processID)
        .set(contract.toJson())
        .whenComplete(() {
      Get.closeAllSnackbars();
      Get.snackbar("Success", "Contract Restored",
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
