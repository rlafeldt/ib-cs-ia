import 'package:flutter/material.dart';

class UserLogo extends StatelessWidget {
  const UserLogo({
    Key? key,
  }) : super(key: key);

//widget to display log in screen icon

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset(
                'lib/assets/images/p_icon.png',
                height: 250,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
