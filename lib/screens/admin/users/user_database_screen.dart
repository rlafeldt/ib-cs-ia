import 'package:flutter/material.dart';
import 'package:app_cs/models/user.dart';

import 'package:app_cs/services/controllers/user_controller.dart';

import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UserDatabaseScreen extends StatelessWidget {
  const UserDatabaseScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List<UserModel>>(
            future: controller.getAllUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<UserModel> userData = snapshot.data as List<UserModel>;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      if (userData[index].isAdmin == false) {
                        return Column(
                          children: [
                            ListTile(
                              iconColor: Colors.blue,
                              tileColor: Colors.blue.withOpacity(0.1),
                              leading: const Icon(LineAwesomeIcons.user_1),
                              title: Text(
                                  "Name: ${userData[index].firstName} ${userData[index].lastName}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email: ${userData[index].email}"),
                                  Text("Admin?: ${userData[index].isAdmin}"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }
                    },
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
        ),
      ),
    );
  }
}
