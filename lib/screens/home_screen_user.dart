import 'package:app_cs/models/user.dart';
import 'package:app_cs/screens/claim_input_screen.dart';
import 'package:app_cs/screens/auth/login_screen.dart';
import 'package:app_cs/screens/contract_input_screen.dart';
import 'package:app_cs/screens/admin/home_screen_admin.dart';
import 'package:app_cs/services/controllers/user_repository.dart';

import 'package:app_cs/services/providers/auth_provider.dart';
import 'package:app_cs/services/controllers/user_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';

class UserMobileHomeScreen extends ConsumerStatefulWidget {
  const UserMobileHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserMobileHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<UserMobileHomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Using GetX to manage UserController and UserRepository instances
    final controller = Get.put(UserController());
    final controller2 = Get.put(UserRepository());

    // Building the main scaffold of the user mobile home screen
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder(
        // Fetching user data asynchronously based on the current user's email
        future: controller
            .getUserData(ref.watch(authProvider).fetchCurrentUser()!.email!),
        builder: (context, snapshot) {
          // Handling different states of the Future
          if (snapshot.connectionState == ConnectionState.done) {
            // When data is successfully fetched and has data
            if (snapshot.hasData) {
              UserModel userData = snapshot.data as UserModel;
              if (userData.isAdmin == true) {
                return const AdminHomeScreen();
              }
              return SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      // used "MediaQuery" to position content relative to the screen size
                      SizedBox(height: MediaQuery.of(context).size.height / 10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        alignment: Alignment.center,
                        child: Text(
                          // Greeting message for the user
                          "Welcome, ${userData.firstName}!",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      // used "MediaQuery" to position content relative to the screen size
                      SizedBox(height: MediaQuery.of(context).size.height / 6),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        height: MediaQuery.of(context).size.height / 10.65,
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ClaimInputScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Claims",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        height: MediaQuery.of(context).size.height / 10.65,
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ContractInputScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Contracts",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 6.5),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        height: MediaQuery.of(context).size.height / 10.65,
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          onPressed: () async {
                            await ref.watch(authProvider).signOut(context);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);

                            Get.offAll(() => const LoginScreen());
                          },
                          child: Text(
                            "Logout",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        height: MediaQuery.of(context).size.height / 10.65,
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          onPressed: () async {
                            await controller2.confirmDeleteAccount(context);
                          },
                          child: Text(
                            "Delete Account",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Text("Something went wrong");
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
