import 'package:app_cs/widgets/contracts/contract_text.dart';
import 'package:flutter/material.dart';

class ContractView extends StatelessWidget {
  const ContractView({
    super.key,
    required this.processID,
    required this.principalValue,
    required this.interestRate,
    required this.executionProcessStartDate,
    required this.executionProcessEndDate,
    required this.fees,
    required this.baseDate,
    required this.firstName,
    required this.lastName,
    required this.contractID,
    required this.cpf,
    required this.rg,
    required this.address,
    required this.cep,
    required this.originProcess,
    required this.birthday,
  });

  final String processID;
  final double principalValue;
  final double interestRate;
  final String executionProcessStartDate;
  final String executionProcessEndDate;
  final double fees;

  final String baseDate;
  final String firstName;
  final String lastName;
  final String contractID;
  final String cpf;
  final String rg;
  final String address;
  final String cep;
  final String originProcess;
  final String birthday;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.all(25),
        child: ContractText(
            processID: processID,
            principalValue: principalValue,
            interestRate: interestRate,
            executionProcessStartDate: executionProcessStartDate,
            executionProcessEndDate: executionProcessEndDate,
            fees: fees,
            baseDate: baseDate,
            firstName: firstName,
            lastName: lastName,
            contractID: contractID,
            cpf: cpf,
            rg: rg,
            address: address,
            cep: cep,
            originProcess: originProcess,
            birthday: birthday),
      ),
    );
  }
}
