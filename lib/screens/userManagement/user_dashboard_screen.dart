import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:zero_waste/models/employee.dart';
import 'package:zero_waste/models/household_user.dart';
import 'package:zero_waste/models/user.dart';
import 'package:zero_waste/providers/user_provider.dart';
import 'package:zero_waste/repositories/employee_repository.dart';
import 'package:zero_waste/repositories/household_user_repository.dart';
import 'package:zero_waste/routes/routes.dart';
import 'package:zero_waste/screens/binManagement/bin_view_screen.dart';
import 'package:zero_waste/screens/binManagement/view_route_screen.dart';
import 'package:zero_waste/screens/home_screen.dart';
import 'package:zero_waste/screens/userManagement/profile_view_screen.dart';
import 'package:zero_waste/utils/custom_bins_icons.dart';
import 'package:zero_waste/utils/user_types.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  late User loginedUser;
  HouseholdUser? householdUser;
  Employee? employee;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLoginedUser();
  }

  void getLoginedUser() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user == null) {
      context.go('/user/login');
    }
    loginedUser = userProvider.user!;
    if (loginedUser.userType == UserTypes.HOUSEHOLD_USER) {
      HouseholdUserRepository()
          .getHouseholdUserByUserId(loginedUser.id)
          .then((fetchedUser) {
        if (fetchedUser != null) {
          setState(() {
            householdUser = fetchedUser;
            employee = null;
            isLoading = false;
          });
        }
      }).catchError((error) {
        okMessageDialog(context, "Failed!", error.toString());
      });
    } else if (loginedUser.userType == UserTypes.EMPLOYEE) {
      EmployeeRepository()
          .getEmployeeByUserId(loginedUser.id)
          .then((fetchedUser) {
        if (fetchedUser != null) {
          setState(() {
            employee = fetchedUser;
            householdUser = null;
            isLoading = false;
          });
        }
      }).catchError((error) {
        okMessageDialog(context, "Failed!", error.toString());
      });
    }
  }

  Widget secondScreen() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (loginedUser.userType == UserTypes.HOUSEHOLD_USER) {
      return BinViewScreen(loginedUser: loginedUser);
    } else if (loginedUser.userType == UserTypes.EMPLOYEE) {
      if (employee!.employeeType == UserTypes.TRUCK_DRIVER) {
        return ViewRouteScreen(loginedUser: loginedUser);
      }
    }
    return const SizedBox(height: 0);
  }

  List<Widget> _navScreens() {
    return [
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : const HomeScreen(),
      secondScreen(),
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProfileViewScreen(
              loginedUser: loginedUser,
              householdUser: householdUser,
              employee: employee),
      isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProfileViewScreen(
              loginedUser: loginedUser,
              householdUser: householdUser,
              employee: employee),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      navItem(Icons.home, "Home"),
      navItem(CustomBins.wasteBin, "Bins"),
      navItem(Icons.notifications, "Notifications"),
      navItem(Icons.person, "Profile"),
    ];
  }

  PersistentBottomNavBarItem navItem(IconData icon, String title) {
    return PersistentBottomNavBarItem(
      icon: Icon(icon),
      title: title,
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _navScreens(),
      items: _navBarItems(),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }
}
