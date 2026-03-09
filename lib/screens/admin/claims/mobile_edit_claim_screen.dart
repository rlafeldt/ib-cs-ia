import 'package:app_cs/models/claim.dart';

import 'package:app_cs/services/controllers/claim_controller.dart';
import 'package:app_cs/services/api/excel_api.dart';
import 'package:app_cs/widgets/inputformatters.dart';

import 'package:app_cs/widgets/myinputfield.dart';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// StatefulWidget for editing claim details in a mobile environment
class MobileEditClaimScreen extends StatefulWidget {
  const MobileEditClaimScreen({super.key, required this.claim});

// Claim object to be edited
  final Claim claim;

  @override
  State<MobileEditClaimScreen> createState() => _MobileEditClaimScreenState();
}

class _MobileEditClaimScreenState extends State<MobileEditClaimScreen> {
  // Global key for the form widget to manage form state
  final _form = GlobalKey<FormState>();

// Text input formatters for process number and date fields
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

// Controller instances for each form field
  var processNumber = TextEditingController();
  var principal = TextEditingController();
  var endDate = TextEditingController();
  var startDate = TextEditingController();
  var rate = TextEditingController();
  var fees = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var baseDate = TextEditingController();
  var amountPaid = TextEditingController();
  var futureValue = TextEditingController();
  var profit = TextEditingController();
  var oldProcessNumber = '';

  @override
  void initState() {
    processNumber = TextEditingController(text: widget.claim.processID);
    oldProcessNumber = widget.claim.processID;
    principal =
        TextEditingController(text: widget.claim.principalValue.toString());
    endDate = TextEditingController(text: widget.claim.executionProcessEndDate);
    startDate =
        TextEditingController(text: widget.claim.executionProcessStartDate);
    rate = TextEditingController(text: widget.claim.interestRate.toString());
    fees = TextEditingController(text: widget.claim.fees.toString());
    firstName = TextEditingController(text: widget.claim.firstName);
    lastName = TextEditingController(text: widget.claim.lastName);
    baseDate = TextEditingController(text: widget.claim.baseDate);
    amountPaid =
        TextEditingController(text: widget.claim.amountPaid.toString());
    futureValue =
        TextEditingController(text: widget.claim.futureValue.toString());
    profit = TextEditingController(text: widget.claim.profit.toString());
    // Initializing controllers with values from the passed Claim object
    super.initState();
  }

  var _isLoading = false;
  var _isLoadingDownload = false;

// Function to download the current claim as an Excel file
  void downloadClaim() async {
    setState(() {
      _isLoadingDownload = true;
    });
    await ExcelApi().downloadClaim(widget.claim);

    setState(() {
      _isLoadingDownload = false;
    });
    // Navigator.of(context).pop();
  }

// Function to submit the edited claim
  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _form.currentState!.save();

    try {
      final claim = Claim(
        processNumber.text.trim(),
        double.parse(principal.text.replaceAll('R\$', '').trim()),
        double.parse(rate.text.replaceAll('%', '').trim()),
        startDate.text.trim(),
        endDate.text.trim(),
        double.parse(fees.text.replaceAll('%', '').trim()),
        widget.claim.uid,
        widget.claim.isActive,
        baseDate.text.trim(),
        firstName.text.trim(),
        lastName.text.trim(),
        double.parse(amountPaid.text.replaceAll('R\$', '').trim()),
        widget.claim.futureValue,
        widget.claim.profit,
      );

      ClaimController.instance.updateClaim(claim, oldProcessNumber);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Building the form UI
    return Form(
      key: _form,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Column(
            // Form fields and action buttons
            children: [
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
              Text(
                "Edit Claim",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 28),
              ),
              const SizedBox(height: 30),
              MyInput(
                labelText: "Process Number",
                textField: TextFormField(
                  controller: processNumber,
                  cursorColor: Colors.black,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [processNumberMaskFormatter],
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
                  onSaved: (value) => processNumber.text = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Principal Value",
                  textField: TextFormField(
                    controller: principal,
                    cursorColor: Colors.black,
                    inputFormatters: [CurrencyInputFormatter()],
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
                    onSaved: (value) => principal.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Amount Paid",
                  textField: TextFormField(
                    controller: amountPaid,
                    cursorColor: Colors.black,
                    inputFormatters: [CurrencyInputFormatter()],
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
                    onSaved: (value) => amountPaid.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Execution Process Start Date",
                  textField: TextFormField(
                    controller: startDate,
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
                    onSaved: (value) => startDate.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Execution Process End Date",
                  textField: TextFormField(
                    controller: endDate,
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
                    onSaved: (value) => endDate.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Interest Rate",
                  textField: TextFormField(
                    controller: rate,
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
                    onSaved: (value) => rate.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Fees",
                  textField: TextFormField(
                    controller: fees,
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
                    onSaved: (value) => fees.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "First Name",
                  textField: TextFormField(
                    controller: firstName,
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
                    onSaved: (value) => firstName.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Last Name",
                  textField: TextFormField(
                    controller: lastName,
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
                    onSaved: (value) => lastName.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Base Date",
                  textField: TextFormField(
                    controller: baseDate,
                    cursorColor: Colors.black,
                    autocorrect: false,
                    inputFormatters: [dateMaskFormatter],
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 18,
                        ),
                    decoration: const InputDecoration(
                        hintText: "dd/mm/yyyy", border: InputBorder.none),
                    validator: validateDate,
                    onSaved: (value) => baseDate.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Future Value",
                  textField: TextFormField(
                    controller: futureValue,
                    cursorColor: Colors.black,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
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
                    onSaved: (value) => futureValue.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Profit",
                  textField: TextFormField(
                    controller: profit,
                    cursorColor: Colors.black,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
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
                    onSaved: (value) => profit.text = value!,
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      20), //when clicked, it will submit claim and display loading indicator
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
                    child: Text("edit claim".toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                            )),
                  ),
                ),
              const SizedBox(height: 30),
              //Download claim button
              if (_isLoadingDownload) const CircularProgressIndicator(),
              if (!_isLoadingDownload)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      downloadClaim();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Text("download claim as spreadsheet".toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                            )),
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
