import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_cs/services/auth/auth_methods.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Defining a provider for AuthMethods, making the authentication methods
// available throughout the app. This provider uses Firebase Auth instance
final authProvider = Provider<AuthMethods>((ref) {
  // The AuthMethods class is initialized with the FirebaseAuth instance.
  // This allows for using Firebase Authentication functionality within AuthMethods
  return AuthMethods(
    FirebaseAuth.instance,
  );
});

// Defining a stream provider for authentication state changes. This provider
// listens to the authentication state (sign-in and sign-out events) and
// provides a User stream. It uses the authProvider defined above to access
// the AuthMethods instance and its authStateChange stream.
final authStateProvider = StreamProvider<User?>((ref) {
  // Watching the authProvider to get an instance of AuthMethods, and then
  // accessing the authStateChange stream. This stream emits events whenever
  // the authentication state changes, for example, when a user signs in or out.
  // The stream emits User? objects, where a null value represents a signed-out state.
  return ref.watch(authProvider).authStateChange;
});
