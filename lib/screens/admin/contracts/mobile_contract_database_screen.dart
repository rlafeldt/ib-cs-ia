import 'package:app_cs/models/contract.dart';
import 'package:app_cs/screens/admin/contracts/mobile_edit_contract_screen.dart';
import 'package:app_cs/services/controllers/contract_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class MobileContractDatabaseScreen extends StatefulWidget {
  const MobileContractDatabaseScreen({super.key});

  @override
  State<MobileContractDatabaseScreen> createState() =>
      _MobileContractDatabaseScreenState();
}

class _MobileContractDatabaseScreenState
    extends State<MobileContractDatabaseScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContractController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          // FutureBuilder widget that awaits the completion of an asynchronous operation.
          //In this case, it's fetching a list of Contract objects.
          child: FutureBuilder<List<Contract>>(
            // The future that this FutureBuilder is observing. The getAllContracts()
            // method is expected to return a Future that completes with a list of Contract objects
            future: controller.getAllContracts(),
            // The builder method of FutureBuilder. It defines the UI that will be built
            // depending on the state of the future (loading, success, error).
            builder: (context, snapshot) {
              // Check if the asynchronous operation has completed.
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // Safely cast the snapshot data to a list of Contract objects.
                  List<Contract> contractData = snapshot.data as List<Contract>;
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
                      // A ListView.builder that creates a list of items dynamically
                      // based on the fetched contract data
                      ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: contractData.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Dismissible(
                                key: ValueKey(contractData[index]),
                                onDismissed: (direction) {
                                  controller.deleteContract(
                                      contractData[index], context);
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
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MobileEditContractScreen(
                                                  contract:
                                                      contractData[index]),
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
                                    leading: const Icon(Icons.article),
                                    trailing: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MobileEditContractScreen(
                                                      contract:
                                                          contractData[index]),
                                            ),
                                          );
                                        },
                                        icon:
                                            const Icon(LineAwesomeIcons.edit)),
                                    title: Text(
                                      "ProcessID: ${contractData[index].processID}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Origin Process: ${contractData[index].originProcess}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          "CPF: ${contractData[index].cpf}",
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
                  return const Center(child: Text("No data"));
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
