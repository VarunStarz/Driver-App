import 'package:driverapp/screens/homescreen.dart';
import 'package:driverapp/screens/statscreen.dart';
import 'package:flutter/material.dart';

class bottomNavScreen extends StatefulWidget {
  const bottomNavScreen({Key? key}) : super(key: key);

  @override
  _bottomNavScreenState createState() => _bottomNavScreenState();
}

class _bottomNavScreenState extends State<bottomNavScreen> {
  final List _screens = [
    homeScreen(),
    statsScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        items: [Icons.home, Icons.insert_chart]
            .asMap()
            .map((key, value) => MapEntry(
                key,
                BottomNavigationBarItem(
                    title: Text(''),
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: _currentIndex == key
                            ? Colors.blue[600]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(value),
                    ))))
            .values
            .toList(),
      ),
    );
  }
}
