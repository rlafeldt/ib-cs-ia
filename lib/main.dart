// Importing necessary packages and screens for the app
import 'package:app_cs/screens/admin/home_screen_admin.dart';
import 'package:app_cs/screens/auth/login_screen.dart';
import 'package:app_cs/screens/home_screen_user.dart';
import 'package:app_cs/screens/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Defining a color scheme for the app's theme
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 122, 255),
);

// Main entry point of the Flutter application
void main() async {
  // Ensuring widget bindings are initialized before runApp is called
  WidgetsFlutterBinding.ensureInitialized();
  // Initializing Firebase with default options for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Running the app with ProviderScope for state management
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

// Root widget of the application
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Using GetMaterialApp for easy route management and theme customization
    return GetMaterialApp(
      // Configuring transition effects for route changes
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 100),
      debugShowCheckedModeBanner: false, // Hiding the debug banner
      title: 'Legal Claim Investment', // Setting the application title

      // Defining the theme of the application using ThemeData
      theme: ThemeData().copyWith(
        useMaterial3: true, // Enabling Material 3 design
        // Customizing the color scheme of the app
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0x00007aff),
          onPrimary: const Color.fromARGB(255, 0, 123, 255),
          primary: const Color(0xff565c95),
          background: const Color(0xfff2f9fe),
          secondary: const Color(0xff3e4784),
        ),
        // Styling for outlined buttons
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              width: 1.5,
              color: Theme.of(context).colorScheme.secondary,
              style: BorderStyle.solid,
            ),
          ),
        ),
        // Customizing the text theme with Google Fonts
        textTheme: ThemeData().textTheme.copyWith(
              bodyMedium: TextStyle(
                fontWeight: FontWeight.normal,
                color: const Color.fromARGB(255, 103, 103, 103),
                fontSize: 16,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
              labelLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 103, 103, 103),
                fontSize: 18,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
              labelSmall: TextStyle(
                fontWeight: FontWeight.normal,
                color: const Color.fromARGB(255, 103, 103, 103),
                fontSize: 13,
                fontFamily: GoogleFonts.lato().fontFamily,
                letterSpacing: 0.2,
              ),
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 30, 30, 30),
                fontSize: 32,
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
            ),
      ),

      // Defining the home property to handle user authentication and navigation
      home: StreamBuilder(
        // Listening to the Firebase Auth state changes
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          // Showing SplashScreen while waiting for the connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          // Navigating to LoginScreen if no user data is found
          if (!snapshot.hasData && snapshot.data == null) {
            return const LoginScreen();
            // Navigating to AdminHomeScreen if the logged-in user is an admin
          } else if (snapshot.data!.email == "admin@gmail.com") {
            return const AdminHomeScreen();
            // Navigating to UserMobileHomeScreen for regular users
          } else {
            return const UserMobileHomeScreen();
          }
        },
      ),
    );
  }
}
