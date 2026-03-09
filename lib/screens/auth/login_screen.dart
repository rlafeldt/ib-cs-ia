import 'package:flutter/material.dart';
import 'package:app_cs/services/responsive.dart';

import 'package:app_cs/widgets/auth/login_form.dart';
import 'package:app_cs/widgets/user_logo.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
          child: Responsive(
            mobile: MobileLoginScreen(),
            desktop: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      UserLogo(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 500),
                        child: LoginForm(),
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

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        const UserLogo(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        const Row(
          children: [
            Spacer(),
            Flexible(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
