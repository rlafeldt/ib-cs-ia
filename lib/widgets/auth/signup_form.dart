import 'package:app_cs/models/user.dart';
import 'package:app_cs/services/controllers/signup_controller.dart';
import 'package:app_cs/widgets/auth/mylogininput.dart';

import 'package:flutter/material.dart';
import 'package:app_cs/services/auth/account_check.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../screens/auth/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

final firebase = FirebaseAuth.instance;

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  final _form = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());
  final _passController = TextEditingController();
  var _isAuthenticating = false;

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
      var enteredEmail = controller.emailController.text.trim();

      var enteredPassword = controller.passwordController.text.trim();
      var enteredFirstName = controller.firstNameController.text.trim();
      var enteredLastName = controller.lastNameController.text.trim();

      await controller.registerUser(enteredEmail, enteredPassword, ref, context,
          enteredFirstName, enteredLastName);

      final user = UserModel(
        email: enteredEmail.toLowerCase(),
        firstName: enteredFirstName,
        lastName: enteredLastName,
        isAdmin: false,
      );

      await SignUpController.instance.createUser(user);
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
    }

    setState(() {
      _isAuthenticating = false;
    });
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
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
                    controller: controller.firstNameController,
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
                      controller.firstNameController.text = value!;
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
                    controller: controller.lastNameController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      controller.lastNameController.text = value!;
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
                controller: controller.emailController,
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
                  controller.emailController.text = value!;
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
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyLoginInput(
              textField: TextFormField(
                textInputAction: TextInputAction.next,
                cursorColor: Colors.black,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                controller: _passController,
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }
                  return null;
                },
                obscureText: _obscureText1,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 15),
                  border: InputBorder.none,
                  hintText: "Password",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText1 ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText1 = !_obscureText1;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: MyLoginInput(
              textField: TextFormField(
                textInputAction: TextInputAction.done,
                cursorColor: Colors.black,
                textCapitalization: TextCapitalization.none,
                controller: controller.passwordController,
                autocorrect: false,
                validator: (value) {
                  if (value != _passController.text) {
                    return 'Passwords must match';
                  }
                  if (value == null || value.trim().length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  controller.passwordController.text = value!;
                },
                obscureText: _obscureText2,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 15),
                  border: InputBorder.none,
                  hintText: "Confirm Password",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText2 ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText2 = !_obscureText2;
                      });
                    },
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
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: Text("Sign Up".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white)),
              ),
            ),
          const SizedBox(height: 16),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
