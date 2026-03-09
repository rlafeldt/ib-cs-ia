import 'package:app_cs/models/user.dart';
import 'package:app_cs/screens/admin/users/mobile_edit_user_screen.dart';

import 'package:app_cs/services/controllers/user_repository.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MobileUserDatabaseScreen extends StatefulWidget {
  const MobileUserDatabaseScreen({super.key});

  @override
  State<MobileUserDatabaseScreen> createState() =>
      _MobileUserDatabaseScreenState();
}

class _MobileUserDatabaseScreenState extends State<MobileUserDatabaseScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserRepository());
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
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                              onPressed: () {
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.refresh,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: userData.length,
                        itemBuilder: (context, index) {
                          if (userData[index].isAdmin == false) {
                            return Column(
                              children: [
                                Dismissible(
                                  key: ValueKey(userData[index]),
                                  onDismissed: (direction) {
                                    controller.deleteUser(
                                        userData[index], context);
                                  },
                                  background: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error
                                          .withOpacity(1),
                                      margin:
                                          Theme.of(context).cardTheme.margin,
                                    ),
                                  ),
                                  child: InkWell(
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MobileEditUserScreen(
                                                    user: userData[index]),
                                          ),
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      iconColor:
                                          Theme.of(context).colorScheme.primary,
                                      tileColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.1),
                                      leading: const Icon(Icons.person),
                                      trailing: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MobileEditUserScreen(
                                                        user: userData[index]),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                              LineAwesomeIcons.edit)),
                                      title: Text(
                                        "Name: ${userData[index].firstName} ${userData[index].lastName}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Email: ${userData[index].email}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  iconColor:
                                      Theme.of(context).colorScheme.primary,
                                  tileColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  leading: const Icon(Icons.person),
                                  trailing: userData[index].isAdmin == true
                                      ? IconButton(
                                          onPressed: () {},
                                          icon:
                                              const Icon(LineAwesomeIcons.edit))
                                      : null,
                                  title: Text(
                                    "Name: ${userData[index].firstName} ${userData[index].lastName}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email: ${userData[index].email}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "Admin?: ${userData[index].isAdmin}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          }
                        },
                      ),
                    ],
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
