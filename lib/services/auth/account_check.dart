// Importing material design library from Flutter
import 'package:flutter/material.dart';

// Defining the AlreadyHaveAnAccountCheck widget as a StatefulWidget to manage state
class AlreadyHaveAnAccountCheck extends StatefulWidget {
  // Boolean value to determine if the current screen is a login screen
  final bool login;
  // Function to be called when the user taps on the "Sign Up" or "Sign In" text
  final Function? press;

  // Constructor with named parameters, with 'login' defaulting to true
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true, // Defaults to true to indicate the login screen
    required this.press, // Function to execute on tap, passed from parent
  }) : super(key: key);

  @override
  // Creating the state for this widget
  State<AlreadyHaveAnAccountCheck> createState() =>
      _AlreadyHaveAnAccountCheckState();
}

// The state class for the AlreadyHaveAnAccountCheck widget
class _AlreadyHaveAnAccountCheckState extends State<AlreadyHaveAnAccountCheck> {
  @override
  Widget build(BuildContext context) {
    // Building the UI for this widget
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centering the row contents
      children: <Widget>[
        // Displaying a text prompt based on the 'login' flag
        Text(
          widget.login
              ? "Don’t have an Account ? " // Text for the login screen
              : "Already have an Account ? ", // Text for the sign-up screen
          style: Theme.of(context).textTheme.bodyMedium, // Applying text theme
        ),
        // Making the "Sign Up" or "Sign In" text clickable
        GestureDetector(
          onTap: widget.press as void
              Function()?, // Executing the passed function on tap
          child: Text(
            widget.login
                ? "Sign Up"
                : "Sign In", // Text based on the 'login' flag
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold), // Making the text bold
          ),
        )
      ],
    );
  }
}
