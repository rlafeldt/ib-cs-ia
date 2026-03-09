// import 'package:app_cs/services/auth/auth_repository.dart';
import 'package:app_cs/models/claim.dart';

import 'package:app_cs/services/controllers/claim_controller.dart';
import 'package:app_cs/widgets/chart/monthly_returns_chart.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MobileAdminDash extends StatefulWidget {
  const MobileAdminDash({super.key});

  @override
  State<MobileAdminDash> createState() => _MobileAdminDashState();
}

class _MobileAdminDashState extends State<MobileAdminDash> {
  List<FlSpot> chartData = [];

  String formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('dd/MM/yyyy - HH:mm');
    return dateFormat.format(dateTime);
  }

  final controller = Get.put(ClaimController());
  Map<String, double> monthlyReturns = {};

  @override
  void initState() {
    super.initState();
    fetchAndProcessClaims();
  }

  void fetchAndProcessClaims() async {
    List<Claim> claims = await controller.getAllClaims();
    Map<String, double> tempMonthlyReturns = {};

    // Get the current year
    int currentYear = DateTime.now().year;
    final dateFormat = DateFormat('dd/MM/yyyy'); // Format to match date strings

    //For-each loop used to directly access element in the List
    for (var claim in claims) {
      // Parse the executionProcessEndDate using the correct format
      DateTime endDate;
      try {
        endDate = dateFormat.parse(claim.executionProcessEndDate);
      } catch (e) {
        continue; // Skip this claim if the date can't be parsed
      }

      // Filter claims by the current year
      if (endDate.year == currentYear) {
        String monthKey = "${endDate.month}-${endDate.year}";
        // Update or initialize the monthly returns
        tempMonthlyReturns.update(monthKey,
            (value) => value + claim.futureValue, // Update existing value
            ifAbsent: () => claim.futureValue // Initialize if key doesn't exist
            );
      }
    }

    setState(() {
      monthlyReturns = tempMonthlyReturns;
      chartData = convertMapToFlSpots(monthlyReturns);
    });
  }

  List<FlSpot> convertMapToFlSpots(Map<String, double> data) {
    final List<FlSpot> spots = [];
    data.forEach((key, value) {
      final month = double.parse(key.split('-')[0]); // Get the month part
      spots.add(FlSpot(month - 1, value));
    });

    // Sorting the list based on month values
    spots.sort((a, b) => a.x.compareTo(b.x));

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClaimController());
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 10),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            alignment: Alignment.topLeft,
            child: Text(
              "Welcome, Admin!",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 45),
          Container(
            width: double.infinity,
            // color: Colors.black,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${DateTime.now().year} Cashflow Projection:",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                    ),
              ),
            ),
          ),
          // SizedBox(height: MediaQuery.of(context).size.height / 65),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: chartData.isNotEmpty
                ? LineChartSample2(myData: chartData)
                : const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 80),
                        CircularProgressIndicator(),
                        SizedBox(height: 15),
                        Text("No data to display yet."),
                      ],
                    ),
                  ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height / 80),

          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent claims:",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                    ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder<List<Claim>>(
              future: controller.fetchRecentClaims(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("No claims found"),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.length > 2) {
                    List<Claim> claimData = snapshot.data!;
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            iconColor: Theme.of(context).colorScheme.primary,
                            tileColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            leading: const Icon(Icons.attach_money_sharp),
                            title: Text(
                              "Process ID: ${claimData[0].processID}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Amount: ${(claimData[0].amountPaid).toStringAsFixed(2)} BRL",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            iconColor: Theme.of(context).colorScheme.primary,
                            tileColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            leading: const Icon(Icons.attach_money_sharp),
                            title: Text(
                              "Process ID: ${claimData[1].processID}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Amount: ${claimData[1].amountPaid} BRL",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            iconColor: Theme.of(context).colorScheme.primary,
                            tileColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            leading: const Icon(Icons.attach_money_sharp),
                            title: Text(
                              "Process ID: ${claimData[2].processID}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Amount: ${claimData[2].amountPaid} BRL",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(
                      child: Column(
                        children: [
                          SizedBox(height: 80),
                          SizedBox(height: 15),
                          Text("No recent claims."),
                        ],
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
