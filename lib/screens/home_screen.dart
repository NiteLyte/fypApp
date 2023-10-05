import 'package:flutter/material.dart';
import 'package:fyp_app/screens/expiry_manager.dart';
import 'package:fyp_app/widget/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  int selectedIndex = 0;
  final List<Widget> _pages = [
    // Define your pages here
    Text("Home Page"),
    Text("Business Page"),
    ExpiryManagerScreen(),
  ];

  void _onItemTapped(int index) {
    // Callback function when a navigation item is tapped.
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("My Cooking Buddy"),
        centerTitle: true,
      ),
      body: Center(child: _pages.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavbar(selectedIndex: selectedIndex, onTap: _onItemTapped),
    );
  }
}
