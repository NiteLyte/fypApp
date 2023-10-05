import 'package:alarm/alarm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/screens/expiry_manager.dart';
import 'package:fyp_app/screens/home_screen.dart';
import 'package:fyp_app/widgets/bottom_navbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await signInAnonymously();
  await Alarm.init(showDebugLogs: true);
  runApp(const MyApp());
}

Future<void> signInAnonymously() async {
  try {
    await FirebaseAuth.instance.signInAnonymously();
    // User is signed in anonymously
    print("---Signed in anoymously---");
  } catch (e) {
    // Handle errors
    print("Error signing in: ${e.toString()}");
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int selectedIndex = 0;
  final List<Widget> _pages = [
    // Define your pages here
    HomeScreen(),
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
      bottomNavigationBar:
          BottomNavbar(selectedIndex: selectedIndex, onTap: _onItemTapped),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
    );
  }
}
