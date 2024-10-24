import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:what_to_eat/what_to_eat/models/what_to_eat_model.dart';
import 'package:what_to_eat/where_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/core/screens/entry_screen.dart';
import 'package:what_to_eat/what_to_eat/screens/what_to_eat_screen.dart';
import 'package:what_to_eat/where_to_eat/screens/where_to_eat_screen.dart';
import 'package:what_to_eat/shared/theme/app_colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<WhatToEatModel>(
          create: (BuildContext context) => WhatToEatModel(),
        ),
        ChangeNotifierProvider<WhereToEatModel>(
          create: (BuildContext context) => WhereToEatModel(),
        )
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.cursorColor,
          selectionHandleColor: AppColors.selectionHandleColor,
        ),
      ),
      home: const MyNavigationBar(),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _currentScreenIndex = 0;

  void _onItemTapped(int index) {
    if (_currentScreenIndex == 1 && index != 1) {
      Provider.of<WhatToEatModel>(context, listen: false)
          .setWhatToEatScreenState(WhatToEatScreenState.categories);
    }
    if (_currentScreenIndex == 2 && index != 2) {
      Provider.of<WhereToEatModel>(context, listen: false)
          .setWhereToEatScreenState(WhereToEatScreenState.initial);
    }
    setState(() {
      _currentScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      EntryScreen(onItemTapped: _onItemTapped),
      const WhatToEatScreen(),
      const WhereToEatScreen(),
      const Text('Settings'),
    ];

    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_currentScreenIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
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
