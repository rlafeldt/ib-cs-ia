import 'package:flutter/material.dart';

class ContractText extends StatelessWidget {
  const ContractText({
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

  String toText() {
    return '''
This Agreement is made this day of $baseDate, by and between $firstName $lastName ("Party") with a principal residence at $address, CEP $cep, and the undersigned entity ("Entity"), pursuant to the process ID $processID.

NOW, THEREFORE, in consideration of the foregoing premises and the mutual covenants contained herein, and for other good and valuable consideration, the receipt and sufficiency of which are hereby acknowledged, the parties agree as follows:

1. Contract Identification:
The contract, identified by Contract ID $contractID, is established for the principal value of $principalValue, attracting an interest rate of $interestRate% per annum.

2. Execution Period:
The execution of this Agreement shall commence on $executionProcessStartDate and shall, unless terminated earlier in accordance with the terms of this Agreement, continue in full force and effect until $executionProcessEndDate ("Execution Period").

3. Fees and Charges:
In consideration for the services to be provided by Entity, Party agrees to pay the fees amounting to $fees.

4. Party Information:
The Party to this Agreement is identified as follows:
- First Name: $firstName
- Last Name: $lastName
- CPF Number: $cpf
- RG Number: $rg
- Date of Birth: $birthday

5. Address for Notice:
Any notice required or permitted by this Agreement shall be in writing and shall be delivered as follows:
- Residential Address: $address, CEP $cep

6. Originating Process:
The originating process for this Agreement is identified by ID $originProcess, forming the basis for the contractual obligations herein.

7. Governing Law:
This Agreement shall be governed by and construed in accordance with the laws of the jurisdiction in which Entity is located, without giving effect to any choice or conflict of law provision or rule.

IN WITNESS WHEREOF, the Parties $firstName $lastName and [Entity Representative] hereto have executed this Agreement as of the Effective Date.
''';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '''
This Agreement is made this day of $baseDate, by and between $firstName $lastName ("Party") with a principal residence at $address, CEP $cep, and the undersigned entity ("Entity"), pursuant to the process ID $processID.

NOW, THEREFORE, in consideration of the foregoing premises and the mutual covenants contained herein, and for other good and valuable consideration, the receipt and sufficiency of which are hereby acknowledged, the parties agree as follows:

1. Contract Identification:
The contract, identified by Contract ID $contractID, is established for the principal value of $principalValue, attracting an interest rate of $interestRate% per annum.

2. Execution Period:
The execution of this Agreement shall commence on $executionProcessStartDate and shall, unless terminated earlier in accordance with the terms of this Agreement, continue in full force and effect until $executionProcessEndDate ("Execution Period").

3. Fees and Charges:
In consideration for the services to be provided by Entity, Party agrees to pay the fees amounting to $fees.

4. Party Information:
The Party to this Agreement is identified as follows:
- First Name: $firstName
- Last Name: $lastName
- CPF Number: $cpf
- RG Number: $rg
- Date of Birth: $birthday

5. Address for Notice:
Any notice required or permitted by this Agreement shall be in writing and shall be delivered as follows:
- Residential Address: $address, CEP $cep

6. Originating Process:
The originating process for this Agreement is identified by ID $originProcess, forming the basis for the contractual obligations herein.

7. Governing Law:
This Agreement shall be governed by and construed in accordance with the laws of the jurisdiction in which Entity is located, without giving effect to any choice or conflict of law provision or rule.

IN WITNESS WHEREOF, the Parties $firstName $lastName and [Entity Representative] hereto have executed this Agreement as of the Effective Date.
''',
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.justify,
    );
  }
}
