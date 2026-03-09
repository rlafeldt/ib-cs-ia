// Define a custom exception class for handling sign-up failures.
class SignUpWithEmailPasswordFailure implements Exception {
  // The message property holds a human-readable error message.
  final String message;

// Constructor with an optional message parameter. If no message is provided,
// a default 'An Unknown error occurred' message is used.
  const SignUpWithEmailPasswordFailure(
      {this.message = 'An Unknown error occurred'});

// Factory constructor that takes an error code (String) and returns
  // an instance of SignUpWithEmailPasswordFailure with a specific error message
  // based on the provided error code. This allows for more descriptive errors
  // based on the Firebase Authentication error codes.
  factory SignUpWithEmailPasswordFailure.code(String code) {
    //Handling of different cases of errors
    switch (code) {
      case 'email-already-in-use':
        return const SignUpWithEmailPasswordFailure(
            message: 'Email already in use');
      case 'invalid-email':
        return const SignUpWithEmailPasswordFailure(message: 'Invalid email');
      case 'weak-password':
        return const SignUpWithEmailPasswordFailure(
            message: 'Please enter a stronger password');
      case 'operation-not-allowed':
        return const SignUpWithEmailPasswordFailure(
            message: 'Operation not allowed');

      case 'wrong-password':
        return const SignUpWithEmailPasswordFailure(
            message: 'The password is incorrect');
      case 'user-disabled':
        return const SignUpWithEmailPasswordFailure(
            message:
                'This user has been disabled. Please contact support for help');
      // For any other error codes not explicitly handled above, return a
      // generic SignUpWithEmailPasswordFailure instance with a default message.
      default:
        return const SignUpWithEmailPasswordFailure();
    }
  }
}
