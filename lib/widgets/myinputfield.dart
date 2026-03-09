import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  const MyInput({
    super.key,
    required this.labelText,
    required this.textField,
  });

  final String labelText;
  //UI and functionality for custom input field

  final TextFormField textField;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.03),
              spreadRadius: 10,
              blurRadius: 3,
              // changes position of shadow
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 15, bottom: 5, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            textField,
          ],
        ),
      ),
    );
  }
}
