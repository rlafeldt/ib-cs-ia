import 'package:app_cs/services/providers/auth_provider.dart';
import 'package:app_cs/widgets/auth/mylogininput.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordForm extends ConsumerStatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  ConsumerState<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends ConsumerState<ForgotPasswordForm> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _isAuthenticating = false;

  void resetPassword() async {
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

    await ref.read(authProvider).resetPassword(context, _enteredEmail);

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
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.none,
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
                _enteredEmail = value!;
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
          const SizedBox(height: 16),
          if (_isAuthenticating) const CircularProgressIndicator(),
          if (!_isAuthenticating)
            Container(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: Text(
                  "reset password".toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
