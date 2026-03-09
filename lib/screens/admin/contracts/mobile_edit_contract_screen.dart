import 'package:app_cs/models/contract.dart';

import 'package:app_cs/services/controllers/contract_controller.dart';
import 'package:app_cs/services/api/pdf_api.dart';
import 'package:app_cs/widgets/contracts/contract_text.dart';

import 'package:app_cs/widgets/myinputfield.dart';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MobileEditContractScreen extends StatefulWidget {
  const MobileEditContractScreen({super.key, required this.contract});

  final Contract contract;

  @override
  State<MobileEditContractScreen> createState() =>
      _MobileEditContractScreenState();
}

class _MobileEditContractScreenState extends State<MobileEditContractScreen> {
  final _form = GlobalKey<FormState>();

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

  var cpf = TextEditingController();
  var rg = TextEditingController();
  var address = TextEditingController();
  var cep = TextEditingController();
  var originProcess = TextEditingController();
  var birthday = TextEditingController();
  var processNumber = TextEditingController();
  var amount = TextEditingController();
  var endDate = TextEditingController();
  var startDate = TextEditingController();
  var rate = TextEditingController();
  var fees = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var baseDate = TextEditingController();
  var amountPaid = TextEditingController();
  var oldProcessNumber = '';

  @override
  void initState() {
    processNumber = TextEditingController(text: widget.contract.processID);
    oldProcessNumber = widget.contract.processID;
    amount =
        TextEditingController(text: widget.contract.principalValue.toString());
    endDate =
        TextEditingController(text: widget.contract.executionProcessEndDate);
    startDate =
        TextEditingController(text: widget.contract.executionProcessStartDate);
    rate = TextEditingController(text: widget.contract.interestRate.toString());
    fees = TextEditingController(text: widget.contract.fees.toString());
    firstName = TextEditingController(text: widget.contract.firstName);
    lastName = TextEditingController(text: widget.contract.lastName);
    baseDate = TextEditingController(text: widget.contract.baseDate);
    cpf = TextEditingController(text: widget.contract.cpf);
    rg = TextEditingController(text: widget.contract.rg);
    address = TextEditingController(text: widget.contract.address);
    cep = TextEditingController(text: widget.contract.cep);
    originProcess = TextEditingController(text: widget.contract.originProcess);
    birthday = TextEditingController(text: widget.contract.birthday);
    amountPaid =
        TextEditingController(text: widget.contract.amountPaid.toString());
    super.initState();
  }

  var _isLoading = false;

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
      final contract = Contract(
        processNumber.text.trim(),
        double.parse(amount.text.trim()),
        double.parse(rate.text.trim()),
        startDate.text.trim(),
        endDate.text.trim(),
        double.parse(fees.text.trim()),
        widget.contract.uid,
        widget.contract.isActive,
        baseDate.text.trim(),
        firstName.text.trim(),
        lastName.text.trim(),
        double.parse(amountPaid.text.trim()),
        widget.contract.futureValue,
        widget.contract.profit,
        widget.contract.contractID,
        cpf.text.trim(),
        rg.text.trim(),
        address.text.trim(),
        cep.text.trim(),
        originProcess.text.trim(),
        birthday.text.trim(),
      );

      ContractController.instance.updateContract(contract, oldProcessNumber);
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
    return Form(
      key: _form,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Column(
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
                "Edit Contract",
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
                  onSaved: (value) => processNumber.text = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Principal Value",
                  textField: TextFormField(
                    controller: amount,
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
                    onSaved: (value) => amount.text = value!,
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
                        hintText: "\$", border: InputBorder.none),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "CPF",
                  textField: TextFormField(
                    controller: cpf,
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
                      return null;
                    },
                    onSaved: (value) => cpf.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "RG",
                  textField: TextFormField(
                    controller: rg,
                    cursorColor: Colors.black,
                    inputFormatters: [rgFormatter],
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
                      return null;
                    },
                    onSaved: (value) => rg.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Address",
                  textField: TextFormField(
                    controller: address,
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
                    onSaved: (value) => address.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "CEP",
                  textField: TextFormField(
                    controller: cep,
                    cursorColor: Colors.black,
                    inputFormatters: [cepFormatter],
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
                      return null;
                    },
                    onSaved: (value) => cep.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Origin Process",
                  textField: TextFormField(
                    controller: originProcess,
                    inputFormatters: [processNumberMaskFormatter],
                    cursorColor: Colors.black,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 18,
                        ),
                    decoration: const InputDecoration(
                        hintText: "0000_000", border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is mandatory';
                      }
                      if (value.length < 25) {
                        return 'Invalid process number';
                      }
                      return null;
                    },
                    onSaved: (value) => originProcess.text = value!,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: MyInput(
                  labelText: "Date of Birth",
                  textField: TextFormField(
                    controller: birthday,
                    cursorColor: Colors.black,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.datetime,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 18,
                        ),
                    decoration: const InputDecoration(
                        hintText: "dd/mm/yyyy", border: InputBorder.none),
                    validator: validateDate,
                    onSaved: (value) => birthday.text = value!,
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
                    child: Text("edit contract".toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                            )),
                  ),
                ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    // call a methed by passing  the text and in return it provide pdf file
                    final pdfFile = await PdfApi.generateCenteredText(
                        ContractText(
                          contractID: widget.contract.contractID,
                          processID: processNumber.text.trim(),
                          principalValue: double.parse(amount.text.trim()),
                          interestRate: double.parse(rate.text.trim()),
                          executionProcessStartDate: startDate.text.trim(),
                          executionProcessEndDate: endDate.text.trim(),
                          fees: double.parse(fees.text.trim()),
                          baseDate: baseDate.text.trim(),
                          firstName: firstName.text.trim(),
                          lastName: lastName.text.trim(),
                          cpf: cpf.text.trim(),
                          rg: rg.text.trim(),
                          address: address.text.trim(),
                          cep: cep.text.trim(),
                          originProcess: originProcess.text.trim(),
                          birthday: birthday.text.trim(),
                        ).toText(),
                        widget.contract.contractID);

                    PdfApi.openFile(pdfFile);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text("download contract as pdf".toUpperCase(),
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
