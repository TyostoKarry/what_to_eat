import 'package:flutter/material.dart';

import 'package:what_to_eat/screens/entry_screen.dart';
import 'package:what_to_eat/theme/app_colors.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyNavigationBar(),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _currentScreenIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Text('Settings'),
      EntryScreen(onItemTapped: _onItemTapped),
      Text('Screen 2'),
      Text('Screen 3'),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_currentScreenIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: 'What to Eat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_sharp),
            label: 'Where to Eat',
          ),
        ],
        currentIndex: _currentScreenIndex,
        selectedItemColor: AppColors.navBarSelectedColor,
        unselectedItemColor: AppColors.navBarUnselectedColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
