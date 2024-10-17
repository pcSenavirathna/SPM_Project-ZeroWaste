import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavigation extends StatelessWidget {
  final List<Widget> screens;
  final List<PersistentBottomNavBarItem> items;

  const BottomNavigation(
      {super.key, required this.screens, required this.items});

  List<Widget> _navScreens() {
    return [
      HomeTab(),
      SearchTab(),
      NotificationsTab(),
      ProfileTab(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      navItem(Icons.home, "Home"),
      navItem(Icons.search, "Search"),
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

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(child: Text("Home Screen")),
    );
  }
}

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search")),
      body: Center(child: Text("Search Screen")),
    );
  }
}

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Center(child: Text("Notifications Screen")),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(child: Text("Profile Screen")),
    );
  }
}
