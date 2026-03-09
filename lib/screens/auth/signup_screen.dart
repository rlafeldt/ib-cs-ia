import 'package:flutter/material.dart';
import 'package:app_cs/services/responsive.dart';
import 'package:app_cs/widgets/user_logo.dart';

import 'package:app_cs/widgets/auth/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
        body: const SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          reverse: true,
          child: Responsive(
            mobile: MobileSignupScreen(),
            desktop: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      UserLogo(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 500),
                        child: SignUpForm(),
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

class MobileSignupScreen extends StatelessWidget {
  const MobileSignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const UserLogo(),
        const Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: SignUpForm(),
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
      ],
    );
  }
}
