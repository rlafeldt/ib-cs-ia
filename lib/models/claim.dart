// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

class Claim {
  String _processID; //inputted
  double _principalValue; //inputted
  double _futureValue; //not inputted
  double _amountPaid; //inputted
  double _profit; //not inputted
  double _interestRate; //inputted
  String _executionProcessStartDate; //inputted
  String _executionProcessEndDate; //inputted
  double _fees; //inputted
  String _uid;
  bool _isActive;
  String _baseDate; //inputted
  String _firstName; //inputted
  String _lastName; //inputted
  DateTime _timeStamp = DateTime.now();

  Claim(
    this._processID,
    this._principalValue,
    this._interestRate,
    this._executionProcessStartDate,
    this._executionProcessEndDate,
    this._fees,
    this._uid,
    this._isActive,
    this._baseDate,
    this._firstName,
    this._lastName,
    this._amountPaid,
    this._futureValue,
    this._profit,
  );

  // factory constructor
  factory Claim.create() {
    return Claim(
      "", // Default value for _processID
      0.0, // Default value for _principalValue
      0.0, // Default value for _interestRate
      "", // Default value for _executionProcessStartDate
      "", // Default value for _executionProcessEndDate
      0.0, // Default value for _fees
      "", // Default value for _uid
      true, // Default value for _isActive
      "", // Default value for _baseDate
      "", // Default value for _firstName
      "", // Default value for _lastName
      0.0, // Default value for _amountPaid
      0.0, // Default value for _futureValue
      0.0, // Default value for _profit
    );
  }

  String get processID => _processID;
  double get principalValue => _principalValue;
  double get interestRate => _interestRate;
  String get executionProcessStartDate => _executionProcessStartDate;
  String get executionProcessEndDate => _executionProcessEndDate;
  double get fees => _fees;
  String get uid => _uid;
  bool get isActive => _isActive;
  String get baseDate => _baseDate;
  String get firstName => _firstName;
  String get lastName => _lastName;
  DateTime get timeStamp => _timeStamp;
  double get amountPaid => _amountPaid;
  double get futureValue => _futureValue;
  double get profit => _profit;

  set processID(String processID) => _processID = processID;
  set principalValue(double principalValue) => _principalValue = principalValue;
  set interestRate(double interestRate) => _interestRate = interestRate;
  set executionProcessStartDate(String executionProcessStartDate) =>
      _executionProcessStartDate = executionProcessStartDate;
  set executionProcessEndDate(String executionProcessEndDate) =>
      _executionProcessEndDate = executionProcessEndDate;
  set fees(double fees) => _fees = fees;
  set uid(String uid) => _uid = uid;
  set isActive(bool isActive) => _isActive = isActive;
  set baseDate(String baseDate) => _baseDate = baseDate;
  set firstName(String firstName) => _firstName = firstName;
  set lastName(String lastName) => _lastName = lastName;

  set amountPaid(double amountPaid) => _amountPaid = amountPaid;
  set futureValue(double futureValue) => _futureValue = futureValue;
  set profit(double profit) => _profit = profit;

  //Convert Claim to map
  fromMap(Map<String, dynamic> map) {
    _processID = map['processID'];
    _principalValue = map['principalValue'];
    _interestRate = map['interestRate'];
    _executionProcessStartDate = map['executionProcessStartDate'];
    _executionProcessEndDate = map['executionProcessEndDate'];
    _fees = map['fees'];
    _uid = map['uid'];
    _isActive = map['isActive'];
    _baseDate = map['baseDate'];
    _firstName = map['firstName'];
    _lastName = map['lastName'];
    _timeStamp = map['timestamp'];
    _amountPaid = map['amountPaid'];
    _futureValue = map['futureValue'];
    _profit = map['profit'];

    return Claim(
      _processID,
      _principalValue,
      _interestRate,
      _executionProcessStartDate,
      _executionProcessEndDate,
      _fees,
      _uid,
      _isActive,
      _baseDate,
      _firstName,
      _lastName,
      _amountPaid,
      _futureValue,
      _profit,
    );
  }

  // Convert Firestore document to Claim
  Claim fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    _processID = data['processID'];
    _principalValue = data['principalValue'];
    _interestRate = data['interestRate'];
    _executionProcessStartDate = data['executionProcessStartDate'];
    _executionProcessEndDate = data['executionProcessEndDate'];
    _fees = data['fees'];
    _uid = data['uid'];
    _isActive = data['isActive'];
    _baseDate = data['baseDate'];
    _firstName = data['firstName'];
    _lastName = data['lastName'];
    _timeStamp = data['timestamp'];
    _amountPaid = data['amountPaid'];
    _futureValue = data['futureValue'];
    _profit = data['profit'];
    return Claim(
      _processID,
      _principalValue,
      _interestRate,
      _executionProcessStartDate,
      _executionProcessEndDate,
      _fees,
      _uid,
      _isActive,
      _baseDate,
      _firstName,
      _lastName,
      _amountPaid,
      _futureValue,
      _profit,
    );
  }

  //Convert claim into a map
  Map<String, dynamic> toMap() {
    return {
      'processID': _processID,
      'principalValue': _principalValue,
      'interestRate': _interestRate,
      'executionProcessStartDate': _executionProcessStartDate,
      'executionProcessEndDate': _executionProcessEndDate,
      'fees': _fees,
      'uid': uid,
      'isActive': _isActive,
      'baseDate': _baseDate,
      'firstName': _firstName,
      'lastName': _lastName,
      'timestamp': _timeStamp,
      'amountPaid': _amountPaid,
      'futureValue': _futureValue,
      'profit': _profit,
    };
  }

  //Converts Claim to Json
  toJson() {
    return {
      'processID': _processID,
      'principalValue': _principalValue,
      'interestRate': interestRate,
      'executionProcessStartDate': _executionProcessStartDate,
      'executionProcessEndDate': _executionProcessEndDate,
      'fees': _fees,
      'uid': _uid,
      'isActive': _isActive,
      'baseDate': _baseDate,
      'firstName': _firstName,
      'lastName': _lastName,
      'timestamp': _timeStamp,
      'amountPaid': _amountPaid,
      'futureValue': _futureValue,
      'profit': _profit,
    };
  }

  //Build cliam from firestore snapshot
  Claim fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Claim(
      data['processID'] ?? '',
      (data['principalValue'] as num).toDouble(),
      (data['interestRate'] as num).toDouble(),
      data['executionProcessStartDate'] ?? '',
      data['executionProcessEndDate'] ?? '',
      (data['fees'] as num).toDouble(),
      data['uid'] ?? '',
      data['isActive'] ?? false,
      data['baseDate'] ?? '',
      data['firstName'] ?? '',
      data['lastName'] ?? '',
      (data['amountPaid'] as num).toDouble(),
      (data['futureValue'] as num).toDouble(),
      (data['profit'] as num).toDouble(),
    );
  }
}
