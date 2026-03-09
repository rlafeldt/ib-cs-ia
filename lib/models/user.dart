import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email; //inputted

  final String firstName; //inputted
  final String lastName; //inputted
  final bool isAdmin; // default false

  const UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isAdmin,
  });

  //Convert User into a map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'isAdmin': isAdmin,
    };
  }

  //build userModel from document Snapshot (firebase)
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      // uid: document.id,
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      isAdmin: data['isAdmin'],
    );
  }
//Build user from map
  UserModel.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        firstName = map['firstName'],
        lastName = map['lastName'],
        isAdmin = map['isAdmin'];

  //Build user from firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      isAdmin: data['isAdmin'],
    );
  }

  //Convert usermodel into JSon
  toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'isAdmin': false,
    };
  }

  //Print user attributes
  @override
  toString() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'isAdmin': false,
    }.toString();
  }
}
