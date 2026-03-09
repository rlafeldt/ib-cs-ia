import 'package:app_cs/models/claim.dart';
import 'package:app_cs/screens/contract_input_screen.dart';
import 'package:app_cs/services/controllers/claim_controller.dart';

import 'package:app_cs/services/providers/auth_provider.dart';
import 'package:app_cs/widgets/inputformatters.dart';

import 'package:app_cs/widgets/myinputfield.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';

class ClaimForm extends ConsumerStatefulWidget {
  const ClaimForm({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ClaimForm> createState() => _ClaimFormState();
}

class _ClaimFormState extends ConsumerState<ClaimForm> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  var processNumberMaskFormatter = MaskTextInputFormatter(
    mask: '#######-##.####.#.##.####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  var dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

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

  final controller = Get.put(ClaimController());

  Claim buildClaim() {
    var currentUserID = ref.watch(authProvider).fetchUserId();
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
    double amountPaidValue =
        double.tryParse(rawAmountPaid) ?? 0; // Handle amountPaid similarly

    var claim = Claim(
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
    );
    controller.claim = claim;

    return claim;
  }

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

    Get.put(ClaimController()).createClaim(buildClaim());

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ContractInputScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // const SizedBox(height: 64),
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
          if (_isLoading) const CircularProgressIndicator(),
          if (!_isLoading)
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
