import 'package:app_cs/services/controllers/login_controller.dart';
import 'package:app_cs/widgets/auth/mylogininput.dart';

import 'package:app_cs/services/providers/auth_provider.dart';

import 'package:flutter/material.dart';

import 'package:app_cs/screens/auth/forgot_password_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../screens/auth/signup_screen.dart';
import 'package:app_cs/services/auth/account_check.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  bool _obscureText = true;
  final _form = GlobalKey<FormState>();
  final controller = Get.put(LogInController());

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
      await controller.logInUser(controller.emailController.text,
          controller.passwordController.text, ref, context);
    } catch (error) {
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
          MyLoginInput(
            textField: TextFormField(
              cursorColor: Colors.black,
              keyboardType: TextInputType.emailAddress,
              controller: controller.emailController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              autocorrect: true,
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
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: MyLoginInput(
              textField: TextFormField(
                controller: controller.passwordController,
                cursorColor: Colors.black,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return 'Password must be at least 6 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  controller.passwordController.text = value!;
                },
                obscureText: _obscureText,
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
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ForgotPasswordScreen();
                    },
                  ),
                );
              },
              child: Text(
                "Forgot Password?",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
                child: Text(
                  "Login".toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}
