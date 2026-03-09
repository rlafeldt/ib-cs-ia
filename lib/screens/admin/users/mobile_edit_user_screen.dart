import 'package:app_cs/models/user.dart';

import 'package:app_cs/services/controllers/user_repository.dart';
import 'package:app_cs/widgets/auth/mylogininput.dart';

import 'package:flutter/material.dart';

class MobileEditUserScreen extends StatefulWidget {
  const MobileEditUserScreen({super.key, required this.user});

  final UserModel user; // UserModel instance to hold the user's current data

  @override
  State<MobileEditUserScreen> createState() => _MobileEditUserScreenState();
}

class _MobileEditUserScreenState extends State<MobileEditUserScreen> {
  final _form = GlobalKey<FormState>();

// TextEditingControllers to manage the input fields
  var email = TextEditingController();
  var firstName = TextEditingController();
  var lastName = TextEditingController();
  var oldEmail = '';

// Initializing the input fields with the user's current data
  @override
  void initState() {
    email = TextEditingController(text: widget.user.email);
    oldEmail = widget.user.email;
    firstName = TextEditingController(text: widget.user.firstName);
    lastName = TextEditingController(text: widget.user.lastName);
    super.initState();
  }

  var _isAuthenticating = false;
  // Function to handle form submission
  void _submit() async {
    setState(() {
      _isAuthenticating = true;
    });
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      setState(() {
        _isAuthenticating = false;
      });
      return;
    }
    _form.currentState!.save();

    try {
      // Creating a new UserModel instance with the updated data
      final user = UserModel(
        email: email.text.trim(),
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        isAdmin: false,
      );
// Updating the user record in the repository
      UserRepository.instance.updateUserRecord(user, oldEmail);
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
    }

    setState(() {
      _isAuthenticating = false;
    });
    Navigator.of(context).pop(); // Returning to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    // Building the form UI
    return Form(
      key: _form,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
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
                  "Edit User",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 28),
                ),
                const SizedBox(height: 250),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.03),
                              spreadRadius: 10,
                              blurRadius: 3,
                              // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: firstName,
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            firstName.text = value!;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "First Name",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.03),
                              spreadRadius: 10,
                              blurRadius: 3,
                              // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          controller: lastName,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            lastName.text = value!;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Last name",
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: MyLoginInput(
                    textField: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      textCapitalization: TextCapitalization.none,
                      cursorColor: Colors.black,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email.text = value!;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 15),
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_isAuthenticating) const CircularProgressIndicator(),
                if (!_isAuthenticating)
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      // onPressed: _submit,
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text("edit user".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
