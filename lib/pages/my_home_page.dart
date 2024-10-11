// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../pages/home_page.dart';
import '../pages/plant_input_page.dart';
import '../pages/plant_list_page.dart';
import '../pages/plant_edit_page.dart';
import '../pages/test_notification_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    PlantInputPage(),
    PlantListPage(),
    PlantEditPage(),
    TestNotificationPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color.fromARGB(255, 29, 141, 29),
        items: [
          TabItem(icon: Icons.home_outlined, title: 'Home'),
          TabItem(icon: Icons.add, title: 'Add Plant'),
          TabItem(icon: Icons.list_alt_outlined, title: 'View Plants'),
          TabItem(icon: Icons.edit_outlined, title: 'Edit Plants'),
          TabItem(icon: Icons.notifications_outlined, title: 'Test'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
