import 'package:flutter/material.dart';
import 'package:ocr/views/home_view.dart';
import 'package:ocr/views/past_view.dart';
import 'package:ocr/views/profile_view.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeView(),
    PastView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.explore),
              label: "Past",
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              label: "Profile",
            ),
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
