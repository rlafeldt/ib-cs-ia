import 'package:flutter/material.dart';

class MyLoginInput extends StatelessWidget {
  const MyLoginInput({super.key, required this.textField});

  final Widget textField;
//custom UI for login input
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.04),
              spreadRadius: 10,
              blurRadius: 3,
              // changes position of shadow
            ),
          ]),
      child: textField,
    );
  }
}
