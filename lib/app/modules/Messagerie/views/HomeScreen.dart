import 'package:StaffFlow/app/components/custom_appbar.dart';

import 'package:flutter/material.dart';
import 'custom_line_indicator_bottom_navbar.dart';
import 'ContactPage.dart';
import 'Home.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; //default index

  List<Widget> _widgetOptions = [
    HomePage(),
    ContactPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomLineIndicatorBottomNavbar(
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
        unSelectedColor: Colors.black54,
        currentIndex: _selectedIndex,
        unselectedIconSize: 15,
        selectedIconSize: 20,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        enableLineIndicator: true,
        lineIndicatorWidth: 3,
        indicatorType: IndicatorType.Top,
        customBottomBarItems: [
          CustomBottomBarItems(
            label: 'Discussions',
            icon: Icons.messenger_outlined,
          ),
          CustomBottomBarItems(
            label: 'Contact',
            icon: Icons.contacts,
          ),
        ],
      ),
    );
  }
}
