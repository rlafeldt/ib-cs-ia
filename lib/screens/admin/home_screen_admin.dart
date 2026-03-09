import 'package:app_cs/screens/admin/admin_dash.dart';
import 'package:app_cs/screens/admin/claims/claim_database_screen.dart';
import 'package:app_cs/screens/admin/contracts/contract_database_screen.dart';
import 'package:app_cs/screens/admin/claims/mobile_claim_database_screen.dart';
import 'package:app_cs/screens/admin/contracts/mobile_contract_database_screen.dart';
import 'package:app_cs/screens/admin/users/mobile_user_database_screen.dart';
import 'package:app_cs/screens/admin/mobile_admin_dash.dart';
import 'package:app_cs/screens/admin/users/user_database_screen.dart';
import 'package:app_cs/screens/auth/login_screen.dart';

import 'package:app_cs/services/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_cs/services/responsive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  int selectedPageIndex = 0;
  List<Widget>? pages;

  @override
  void initState() {
    pages = [
      const MobileAdminDash(),
      const MobileUserDatabaseScreen(),
      const MobileContractDatabaseScreen(),
      const MobileClaimDatabaseScreen(),
      const CircularProgressIndicator(),
    ];
    super.initState();
  }

  Widget _createBottomNavigationBar() {
    return NavigationRail(
      extended: isExpanded,
      backgroundColor: Colors.deepPurple.shade400,
      unselectedIconTheme: const IconThemeData(color: Colors.white, opacity: 1),
      unselectedLabelTextStyle:
          Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
      selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade900),
      selectedIndex: selectedPageIndex,
      onDestinationSelected: (index) async {
        _selectPage(index);
        print(index);
        if (index == 0) {
          MaterialPageRoute(
            builder: (context) => const MobileAdminDash(),
          );
        }
        if (index == 1) {
          MaterialPageRoute(
            builder: (context) => const MobileUserDatabaseScreen(),
          );
        }
        if (index == 2) {
          MaterialPageRoute(
            builder: (context) => const MobileContractDatabaseScreen(),
          );
        }
        if (index == 3) {
          MaterialPageRoute(
            builder: (context) => const CircularProgressIndicator(),
          );
        }
        if (index == 4) {
          MaterialPageRoute(
              builder: (context) => const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()));

          await ref.watch(authProvider).signOut(context);
        }
      },
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text("Home"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          label: Text("Employees"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.article),
          label: Text("Contracts"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.monetization_on_outlined),
          label: Text("Claims"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.logout),
          label: Text("Logout"),
        ),
      ],
    );
  }

  void _selectPage(index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: const MobileAdminHomeScreen(),
        // desktop: pages![selectedPageIndex],
        desktop: Row(
          children: [
            _createBottomNavigationBar(),
            const AdminDash(),
          ],
        ),
      ),
    );
  }
}

class MobileAdminHomeScreen extends ConsumerStatefulWidget {
  const MobileAdminHomeScreen({super.key});

  @override
  ConsumerState<MobileAdminHomeScreen> createState() =>
      _MobileAdminHomeScreenState();
}

class _MobileAdminHomeScreenState extends ConsumerState<MobileAdminHomeScreen> {
  int selectedPageIndex = 0;
  List<Widget>? pages;

  @override
  void initState() {
    pages = [
      const MobileAdminDash(),
      const MobileUserDatabaseScreen(),
      const MobileContractDatabaseScreen(),
      const MobileClaimDatabaseScreen(),
      const CircularProgressIndicator(),
    ];
    super.initState();
  }

  void _selectPage(index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  Widget _createBottomNavigationBar() {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: GNav(
          curve: Curves.easeIn,
          color: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          activeColor: Theme.of(context).colorScheme.secondary,
          tabBackgroundColor: Theme.of(context).colorScheme.background,
          iconSize: 25,
          padding: const EdgeInsets.all(15),
          gap: 8,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.person,
              text: 'Users',
            ),
            GButton(
              icon: Icons.article,
              text: 'Contracts',
            ),
            GButton(
              icon: Icons.monetization_on_outlined,
              text: 'Claims',
            ),
            GButton(
              icon: Icons.logout,
              text: 'Logout',
            ),
          ],
          selectedIndex: selectedPageIndex,
          onTabChange: (index) async {
            _selectPage(index);
            if (index == 4) {
              await ref.watch(authProvider).signOut(context);
              Get.offAll(() => const LoginScreen());
              // Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: _createBottomNavigationBar(),
      body: pages![selectedPageIndex],
    );
  }
}
