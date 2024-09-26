import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/screens/entry_screen.dart';
import 'package:what_to_eat/screens/what_to_eat_screen.dart';
import 'package:what_to_eat/theme/app_colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WhatToEatModel(),
      child: const MainApp(),
    ),
  );
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
    if (_currentScreenIndex == 2 && index != 2) {
      Provider.of<WhatToEatModel>(context, listen: false)
          .setWhatToEatScreenState(WhatToEatScreenState.categories);
    }
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Text('Settings'),
      EntryScreen(onItemTapped: _onItemTapped),
      WhatToEatScreen(),
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
            backgroundColor: AppColors.navBarBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.navBarBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_sharp),
            label: 'What to Eat',
            backgroundColor: AppColors.navBarBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Where to Eat',
            backgroundColor: AppColors.navBarBackgroundColor,
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
