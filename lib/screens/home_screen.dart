import 'package:flutter/material.dart';
import 'package:fyp_app/screens/expiry_manager.dart';
import 'package:fyp_app/widgets/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // int selectedIndex = 0;
  // final List<Widget> _pages = [
  //   // Define your pages here
  //   Text("Home Page"),
  //   Text("Business Page"),
  //   ExpiryManagerScreen(),
  // ];

  // void _onItemTapped(int index) {
  //   // Callback function when a navigation item is tapped.
  //   setState(() {
  //     selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("home screen"),
      ),
    );
  }
}
