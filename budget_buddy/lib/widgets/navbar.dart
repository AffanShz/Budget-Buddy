// BottomNavbar.dart
// ignore_for_file: unused_field, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screens/home.dart';
import '../screens/add.dart';
import '../screens/statistic.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    Home(),
    Addscreen(),
    Statistic()
  ]; // Screens list

  void _navigate(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff365486),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15),
        child: GNav(
          color: Colors.white,
          backgroundColor: Color(0xff365486),
          padding: EdgeInsets.all(14),
          gap: 7,
          selectedIndex: _selectedIndex,
          onTabChange: _navigate,
          tabs: [
            GButton(
              icon: Icons.home,
              iconActiveColor: Colors.white,
              iconColor: Colors.white,
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              ), //
            ),
            GButton(
              icon: Icons.add,
              iconActiveColor: Colors.white,
              iconColor: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Addscreen()),
              ),
            ),
            GButton(
              icon: Icons.bar_chart,
              iconActiveColor: Colors.white,
              iconColor: Colors.white,
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Statistic()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
