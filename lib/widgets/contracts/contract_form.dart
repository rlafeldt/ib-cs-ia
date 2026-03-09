import 'package:app_cs/models/claim.dart';
import 'package:app_cs/models/contract.dart';
import 'package:app_cs/services/controllers/claim_controller.dart';

import 'package:app_cs/services/controllers/contract_controller.dart';
import 'package:app_cs/services/providers/auth_provider.dart';
import 'package:app_cs/widgets/inputformatters.dart';

import 'package:app_cs/widgets/myinputfield.dart';
import 'package:app_cs/screens/contract_display_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ContractForm extends ConsumerStatefulWidget {
  const ContractForm({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ContractForm> createState() => _ContractFormState();
}

class _ContractFormState extends ConsumerState<ContractForm> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for form validation
  var _isLoading = false; // Boolean flag to manage loading state

  // Initializing controllers for managing contract and claim data
  final controller = Get.put(ContractController());
  final claimController = Get.put(ClaimController());

  // Input formatters for various fields like process number, date, CPF, RG, and CEP
  // Each formatter uses regular expressoins to ensure the input follows a specific pattern,
  //such as '#######-##.####.#.##.####' for process numbers
  var processNumberMaskFormatter = MaskTextInputFormatter(
      mask: '#######-##.####.#.##.####', filter: {"#": RegExp(r'[0-9]')});

  var dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  var cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###.##', filter: {"#": RegExp(r'[0-9]')});

  var rgFormatter = MaskTextInputFormatter(
      mask: '##.###.###-#', filter: {"#": RegExp(r'[0-9]')});

  var cepFormatter = MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

// Validator function for date fields
  String? validateDate(String? value) {
    // Check if the input value is null or empty, indicating that no date was entered.
    if (value == null || value.isEmpty) {
      return 'Date is required'; // Return an error message indicating that the date field cannot be empty.
    }
    // Split the input string by '/' to separate the day, month, and year parts of the date.
    List<String> parts = value.split('/');
    // Check if the resulting array does not have exactly three parts, indicating an incorrect format.
    if (parts.length != 3) {
      return 'Invalid date format'; // Return an error message indicating that the date format is incorrect.
    }
    // Attempt to parse the day, month, and year parts of the date string into integers.
    int? day = int.tryParse(parts[0]);
    int? month = int.tryParse(parts[1]);
    int? year = int.tryParse(parts[2]);
    // Check if any of the parsed values are null, indicating that the day, month, or year could not be parsed into an integer.
    if (day == null || month == null || year == null) {
      return 'Invalid date'; // Return an error message
    }
    try {
      // Attempt to create a DateTime object using the parsed day, month, and year.
      final date = DateTime(year, month, day);
      // Check if the created DateTime object does not match the input values,
      // which can happen if an invalid date was entered (e.g., February 30).
      if (date.year != year || date.month != month || date.day != day) {
        return 'Invalid date';
      }
    } catch (e) {
      // Catch any exceptions thrown by the DateTime constructor, which would indicate an invalid date.
      return 'Invalid date';
    }
    return null; // return null if the date is valid
  }

  // Function to construct a Contract object from the form inputs
  Contract buildContract() {
    var currentUserID = ref.read(authProvider).fetchUserId();
    // Remove formatting from amount and rate
    String rawAmount = controller.amount.text.replaceAll('R\$', '').trim();
    String rawRate = controller.rate.text.replaceAll('%', '').trim();
    String rawFee = controller.fees.text.replaceAll('%', '').trim();
    String rawAmountPaid =
        controller.amountPaid.text.replaceAll('R\$', '').trim();

    // Safely parse the numbers, providing a fallback value in case of failure
    double amountValue =
        double.tryParse(rawAmount) ?? 0; // Fallback to 0 if parsing fails
    double rateValue =
        double.tryParse(rawRate) ?? 0; // Fallback to 0 if parsing fails
    double feesValue = double.tryParse(rawFee) ?? 0; // Handle fees similarly
    double amountPaidValue = double.tryParse(rawAmountPaid) ?? 0;

    var contract = Contract(
      controller.processNumber.text,
      amountValue,
      rateValue,
      controller.startDate.text,
      controller.endDate.text,
      feesValue,
      currentUserID,
      true,
      controller.baseDate.text,
      controller.firstName.text,
      controller.lastName.text,
      amountPaidValue,
      0,
      0,
      controller.processNumber.text,
      controller.cpf.text,
      controller.rg.text,
      controller.address.text,
      controller.cep.text,
      controller.originProcess.text,
      controller.birthday.text,
    );

    return contract;
  }

// Function to pre-fill the form with data from a previous claim if available
  void _fillWithPreviousClaim(Claim? claim) {
    // Check if the passed claim object is null or if the principal value of the claim is 0,
    // indicating there's no valid claim data to fill the form with.
    if (claim == null || claim.principalValue == 0) {
      Get.closeAllSnackbars();
      Get.snackbar("Error",
          "No previous claim", // Show an error message to the user indicating no previous claim is available.
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      return; // Exit the method as there's no claim data to fill in.
    }
    // Exit the method as there's no claim data to fill in.
    setState(() {
      _isLoading = true;
    });
// Convert the claim object into a map to easily access its properties.
    Map claimMap = claim.toMap();
// Fill each form controller with the corresponding value from the claim map.
    // This prepopulates the form fields with the data from the previous claim.
    controller.processNumber.text = claimMap['processID'];
    controller.amount.text = claimMap['principalValue'].toString();
    controller.startDate.text = claimMap['executionProcessStartDate'];
    controller.endDate.text = claimMap['executionProcessEndDate'];
    controller.rate.text = claimMap['interestRate'].toString();
    controller.fees.text = claimMap['fees'].toString();
    controller.firstName.text = claimMap['firstName'];
    controller.lastName.text = claimMap['lastName'];
    controller.baseDate.text = claimMap['baseDate'];
    controller.amountPaid.text = claimMap['amountPaid'].toString();
// After filling the form, set loading state to false to indicate the process is complete.
    setState(() {
      _isLoading = false;
    });
  }

  // Function to handle form submission, including form validation and data saving
  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formKey.currentState!.save();

    Get.put(ContractController()).createContract(buildContract());

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContractDisplayScreen(
          contract: buildContract,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Building the form UI
    return Form(
      key: _formKey,
      child: Column(
        children: [
// Various input fields like 'Process Number', 'Principal Value', 'Execution Process Start Date', etc.
          // Each input field uses a MyInput widget, which internally uses TextFormField for data entry
          // Input fields are validated and formatted as per the defined input formatters and validator functions

          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          MyInput(
            labelText: "Process Number",
            textField: TextFormField(
              controller: controller.processNumber,
              cursorColor: Colors.black,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              inputFormatters: [processNumberMaskFormatter],
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 18,
                  ),
              decoration: const InputDecoration(
                  hintText: "0000000-00.0000.0.00.0000",
                  border: InputBorder.none),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is mandatory';
                }
                if (value.length < 25) {
                  return 'Invalid process number';
                }
                return null;
              },
              onSaved: (value) => controller.processNumber.text = value!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Principal Value",
              textField: TextFormField(
                controller: controller.amount,
                inputFormatters: [CurrencyInputFormatter()],
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "R\$", border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  return null;
                },
                onSaved: (value) => controller.amount.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Amount Paid",
              textField: TextFormField(
                controller: controller.amountPaid,
                inputFormatters: [CurrencyInputFormatter()],
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "R\$", border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  return null;
                },
                onSaved: (value) => controller.amountPaid.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Execution Process Start Date",
              textField: TextFormField(
                controller: controller.startDate,
                cursorColor: Colors.black,
                inputFormatters: [dateMaskFormatter],
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.datetime,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "dd/mm/yyyy", border: InputBorder.none),
                validator: validateDate,
                onSaved: (value) => controller.startDate.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Execution Process End Date",
              textField: TextFormField(
                controller: controller.endDate,
                inputFormatters: [dateMaskFormatter],
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.datetime,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "dd/mm/yyyy", border: InputBorder.none),
                validator: validateDate,
                onSaved: (value) => controller.endDate.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Interest Rate",
              textField: TextFormField(
                controller: controller.rate,
                inputFormatters: [PercentageInputFormatter()],
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "%", border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  return null;
                },
                onSaved: (value) => controller.rate.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Fees",
              textField: TextFormField(
                controller: controller.fees,
                inputFormatters: [PercentageInputFormatter()],
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "%", border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  return null;
                },
                onSaved: (value) => controller.fees.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "First Name",
              textField: TextFormField(
                controller: controller.firstName,
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "", border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  return null;
                },
                onSaved: (value) => controller.firstName.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Last Name",
              textField: TextFormField(
                controller: controller.lastName,
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "", border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  return null;
                },
                onSaved: (value) => controller.lastName.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Base Date",
              textField: TextFormField(
                controller: controller.baseDate,
                inputFormatters: [dateMaskFormatter],
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "dd/mm/yyyy", border: InputBorder.none),
                validator: validateDate,
                onSaved: (value) => controller.baseDate.text = value!,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  width: 1.5,
                  color: Theme.of(context).colorScheme.onPrimary,
                  style: BorderStyle.solid,
                ),
              ),
              onPressed: () => _fillWithPreviousClaim(claimController.claim),
              child: Text(
                "Fill with previous claim",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "CPF",
              textField: TextFormField(
                controller: controller.cpf,
                inputFormatters: [cpfFormatter],
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "___.___.___.__", border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  if (value.length < 14) {
                    return 'Invalid CPF';
                  }
                  return null;
                },
                onSaved: (value) => controller.cpf.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "RG",
              textField: TextFormField(
                controller: controller.rg,
                inputFormatters: [rgFormatter],
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "__.___.___-_", border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  if (value.length < 12) {
                    return 'Invalid RG';
                  }
                  return null;
                },
                onSaved: (value) => controller.rg.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Address",
              textField: TextFormField(
                controller: controller.address,
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "", border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  return null;
                },
                onSaved: (value) => controller.address.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "CEP",
              textField: TextFormField(
                controller: controller.cep,
                inputFormatters: [cepFormatter],
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "_____-___", border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  if (value.length < 9) {
                    return 'Invalid CEP';
                  }
                  return null;
                },
                onSaved: (value) => controller.cep.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Origin Process",
              textField: TextFormField(
                controller: controller.originProcess,
                cursorColor: Colors.black,
                inputFormatters: [processNumberMaskFormatter],
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "0000000-00.0000.0.00.0000",
                    border: InputBorder.none),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is mandatory';
                  }
                  if (value.length < 25) {
                    return 'Invalid process number';
                  }
                  return null;
                },
                onSaved: (value) => controller.originProcess.text = value!,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyInput(
              labelText: "Date of Birth",
              textField: TextFormField(
                controller: controller.birthday,
                cursorColor: Colors.black,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.datetime,
                inputFormatters: [dateMaskFormatter],
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
                decoration: const InputDecoration(
                    hintText: "dd/mm/yyyy", border: InputBorder.none),
                validator: validateDate,
                onSaved: (value) => controller.birthday.text = value!,
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (_isLoading) const CircularProgressIndicator(),
          if (!_isLoading)
            // 'Submit' button to trigger the _submit function, which handles form validation and submission

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: Text("Submit".toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        )),
              ),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
