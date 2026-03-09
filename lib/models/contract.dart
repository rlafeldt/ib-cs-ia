// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_getters_setters

import 'package:app_cs/models/claim.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Contract is a subclass of Claim. It inherits properties and behaviors (methods) from the Claim class
//such as principalValue and fees, but also has additional properties and behaviors specific to a Contract.

class Contract extends Claim {
  String _contractID;
  String _cpf;
  String _rg;
  String _address;
  String _cep;
  String _originProcess;
  String _birthday;

  Contract(
    String processID,
    double principalValue,
    double interestRate,
    String executionProcessStartDate,
    String executionProcessEndDate,
    double fees,
    String uid,
    bool isActive,
    String baseDate,
    String firstName,
    String lastName,
    double amountPaid,
    double futureValue,
    double profit,
    this._contractID,
    this._cpf,
    this._rg,
    this._address,
    this._cep,
    this._originProcess,
    this._birthday,
  ) : super(
          processID,
          principalValue,
          interestRate,
          executionProcessStartDate,
          executionProcessEndDate,
          fees,
          uid,
          isActive,
          baseDate,
          firstName,
          lastName,
          amountPaid,
          0.0,
          0.0,
        );

  factory Contract.create() {
    return Contract(
      '',
      0.0,
      0.0,
      '',
      '',
      0.0,
      '',
      false,
      '',
      '',
      '',
      0.0,
      0.0,
      0.0,
      '',
      '',
      '',
      '',
      '',
      "",
      "",
    );
  }

  String get contractID => _contractID;
  String get cpf => _cpf;
  String get rg => _rg;
  String get address => _address;
  String get cep => _cep;
  String get originProcess => _originProcess;
  String get birthday => _birthday;

  set contractID(String contractID) => _contractID = contractID;
  set cpf(String cpf) => _cpf = cpf;
  set rg(String rg) => _rg = rg;
  set address(String address) => _address = address;
  set cep(String cep) => _cep = cep;

  set originProcess(String originProcess) => _originProcess = originProcess;
  set birthday(String birthday) => _birthday = birthday;

  // Override toMap method
  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'contractID': _contractID,
      'cpf': _cpf,
      'rg': _rg,
      'address': _address,
      'cep': _cep,
      'originProcess': _originProcess,
      'birthday': _birthday,
    });
    return map;
  }

//Polymorphism: Provides more specific implementation of fromMap method from Claims class.
  @override
  fromMap(Map<String, dynamic> map) {
    super.fromMap(map); //call to the super class method.
    _contractID = map['contractID'];
    _cpf = map['cpf'];
    _rg = map['rg'];
    _address = map['address'];
    _cep = map['cep'];
    _originProcess = map['originProcess'];
    _birthday = map['birthday'];
    return this;
  }

  // Convert Firestore document to Contract
  @override
  Contract fromDocument(DocumentSnapshot doc) {
    super.fromDocument(doc);
    final data = doc.data() as Map<String, dynamic>;
    _contractID = data['contractID'];
    _cpf = data['cpf'];
    _rg = data['rg'];
    _address = data['address'];
    _cep = data['cep'];
    _originProcess = data['originProcess'];
    _birthday = data['birthday'];
    return this;
  }

  factory Contract.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Contract(
      data['processID'] ?? '',
      (data['principalValue'] as num?)?.toDouble() ?? 0.0,
      (data['interestRate'] as num?)?.toDouble() ?? 0.0,
      data['executionProcessStartDate'] ?? '',
      data['executionProcessEndDate'] ?? '',
      (data['fees'] as num?)?.toDouble() ?? 0.0,
      data['uid'] ?? '',
      data['isActive'] ?? false,
      data['baseDate'] ?? '',
      data['firstName'] ?? '',
      data['lastName'] ?? '',
      (data['amountPaid'] as num?)?.toDouble() ?? 0.0,
      data['futureValue'] ?? '',
      data['profit'] ?? '',
      data['contractID'] ?? '',
      data['cpf'] ?? '',
      data['rg'] ?? '',
      data['address'] ?? '',
      data['cep'] ?? '',
      data['originProcess'] ?? '',
      data['birthday'] ?? '',
    );
  }

  // The toJson method for Contract
  @override
  Map<String, dynamic> toJson() {
    // First, serialize the inherited Claim fields using Claim's toJson
    final map = super.toJson();

    // Then, add the Contract-specific fields to the map
    map.addAll({
      'contractID': _contractID,
      'cpf': _cpf,
      'rg': _rg,
      'address': _address,
      'cep': _cep,
      'originProcess': _originProcess,
      'birthday': _birthday,
      // Add other Contract-specific fields here
    });

    return map;
  }
}
