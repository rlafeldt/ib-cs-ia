import 'package:app_cs/models/contract.dart';
import 'package:app_cs/widgets/contracts/contract_view.dart';
import 'package:flutter/material.dart';
import 'package:app_cs/services/responsive.dart';

class ContractDisplayScreen extends StatelessWidget {
  const ContractDisplayScreen({
    Key? key,
    required this.contract,
  }) : super(key: key);

  final Contract Function() contract;

  Map<String, dynamic> contractData(Function() contract) {
    Map<String, dynamic> contractData = {
      "processID": contract().processID,
      "principalValue": contract().principalValue,
      "interestRate": contract().interestRate,
      "executionProcessStartDate": contract().executionProcessStartDate,
      "executionProcessEndDate": contract().executionProcessEndDate,
      "fees": contract().fees,
      "baseDate": contract().baseDate,
      "firstName": contract().firstName,
      "lastName": contract().lastName,
      "contractID": contract().contractID,
      "cpf": contract().cpf,
      "rg": contract().rg,
      "address": contract().address,
      "cep": contract().cep,
      "originProcess": contract().originProcess,
      "birthday": contract().birthday,
    };
    return contractData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Responsive(
            mobile: MobileContractDisplayScreen(
              contract: contract,
            ),
            desktop: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 450,
                        child: ContractView(
                          contractID: contractData(contract)["contractID"],
                          processID: contractData(contract)["processID"],
                          principalValue:
                              contractData(contract)["principalValue"],
                          interestRate: contractData(contract)["interestRate"],
                          executionProcessStartDate: contractData(
                              contract)["executionProcessStartDate"],
                          executionProcessEndDate:
                              contractData(contract)["executionProcessEndDate"],
                          fees: contractData(contract)["fees"],
                          baseDate: contractData(contract)["baseDate"],
                          firstName: contractData(contract)["firstName"],
                          lastName: contractData(contract)["lastName"],
                          cpf: contractData(contract)["cpf"],
                          rg: contractData(contract)["rg"],
                          address: contractData(contract)["address"],
                          cep: contractData(contract)["cep"],
                          originProcess:
                              contractData(contract)["originProcess"],
                          birthday: contractData(contract)["birthday"],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileContractDisplayScreen extends StatelessWidget {
  const MobileContractDisplayScreen({
    Key? key,
    required this.contract,
  }) : super(key: key);

  final Contract Function() contract;

  Map<String, dynamic> contractData(Function() contract) {
    Map<String, dynamic> contractData = {
      "processID": contract().processID,
      "principalValue": contract().principalValue,
      "interestRate": contract().interestRate,
      "executionProcessStartDate": contract().executionProcessStartDate,
      "executionProcessEndDate": contract().executionProcessEndDate,
      "fees": contract().fees,
      "baseDate": contract().baseDate,
      "firstName": contract().firstName,
      "lastName": contract().lastName,
      "contractID": contract().contractID,
      "cpf": contract().cpf,
      "rg": contract().rg,
      "address": contract().address,
      "cep": contract().cep,
      "originProcess": contract().originProcess,
      "birthday": contract().birthday,
    };
    return contractData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 40,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Contract #${contractData(contract)["processID"]}",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        Flexible(
          flex: 8,
          child: ContractView(
            contractID: contractData(contract)["contractID"],
            processID: contractData(contract)["processID"],
            principalValue: contractData(contract)["principalValue"],
            interestRate: contractData(contract)["interestRate"],
            executionProcessStartDate:
                contractData(contract)["executionProcessStartDate"],
            executionProcessEndDate:
                contractData(contract)["executionProcessEndDate"],
            fees: contractData(contract)["fees"],
            baseDate: contractData(contract)["baseDate"],
            firstName: contractData(contract)["firstName"],
            lastName: contractData(contract)["lastName"],
            cpf: contractData(contract)["cpf"],
            rg: contractData(contract)["rg"],
            address: contractData(contract)["address"],
            cep: contractData(contract)["cep"],
            originProcess: contractData(contract)["originProcess"],
            birthday: contractData(contract)["birthday"],
          ),
        ),
      ],
    );
  }
}
