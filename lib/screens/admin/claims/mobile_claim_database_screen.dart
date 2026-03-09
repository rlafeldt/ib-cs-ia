import 'package:app_cs/models/claim.dart';
import 'package:app_cs/screens/admin/claims/mobile_edit_claim_screen.dart';

import 'package:app_cs/services/controllers/claim_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MobileClaimDatabaseScreen extends StatefulWidget {
  const MobileClaimDatabaseScreen({super.key});

  @override
  State<MobileClaimDatabaseScreen> createState() =>
      _MobileClaimDatabaseScreenState();
}

class _MobileClaimDatabaseScreenState extends State<MobileClaimDatabaseScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClaimController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List<Claim>>(
            future: controller.getAllClaims(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<Claim> claimData = snapshot.data as List<Claim>;
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
                        itemCount: claimData.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Dismissible(
                                key: ValueKey(claimData[index]),
                                onDismissed: (direction) {
                                  controller.deleteClaim(
                                      claimData[index], context);
                                },
                                background: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .error
                                        .withOpacity(1),
                                    margin: Theme.of(context).cardTheme.margin,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MobileEditClaimScreen(
                                                claim: claimData[index]),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    iconColor:
                                        Theme.of(context).colorScheme.primary,
                                    tileColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1),
                                    leading:
                                        const Icon(Icons.attach_money_sharp),
                                    trailing: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MobileEditClaimScreen(
                                                      claim: claimData[index]),
                                            ),
                                          );
                                        },
                                        icon:
                                            const Icon(LineAwesomeIcons.edit)),
                                    title: Text(
                                      "Process ID: ${claimData[index].processID}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Amount: ${(claimData[index].principalValue).toStringAsFixed(2)} BRL",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          "Future Value: ${(claimData[index].futureValue).toStringAsFixed(2)} BRL",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          "Profit: ${(claimData[index].profit).toStringAsFixed(2)} BRL",
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
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Text(snapshot.error.toString());
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
