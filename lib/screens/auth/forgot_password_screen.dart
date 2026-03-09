import 'package:flutter/material.dart';
import 'package:app_cs/services/responsive.dart';
import 'package:app_cs/widgets/user_logo.dart';

import '../../widgets/auth/forgot_password_form.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 150, 215, 199),
);

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Responsive(
            mobile: const MobileForgotPasswordScreen(),
            desktop: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
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
                      const SizedBox(
                        height: 40,
                      ),
                      const UserLogo(),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 500),
                        child: ForgotPasswordForm(),
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

class MobileForgotPasswordScreen extends StatelessWidget {
  const MobileForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.06),
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.223),
        Row(
          children: [
            const Spacer(),
            Flexible(
              flex: 8,
              child: Text(
                'Receive an email to reset your password.',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kColorScheme.onSecondaryContainer,
                    fontSize: 20),
              ),
            ),
            const Spacer(),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        const Row(
          children: [
            Spacer(),
            Flexible(
              flex: 8,
              child: ForgotPasswordForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
