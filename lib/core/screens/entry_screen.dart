import 'package:flutter/material.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_safe_area.dart';
import 'package:what_to_eat/core/widgets/wte_split_screen_animation.dart';

class EntryScreen extends StatefulWidget {
  final Function onItemTapped;

  const EntryScreen({super.key, required this.onItemTapped});

  @override
  EntryScreenState createState() => EntryScreenState();
}

class EntryScreenState extends State<EntryScreen> {
  int? _selectedSide;

  void _onSideSelected(int side) {
    setState(() {
      _selectedSide = side;
    });

    Future<void>.delayed(const Duration(milliseconds: 150), () {
      widget.onItemTapped(side);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedSide != null) {
      return WTESplitScreenAnimation(expandLeft: _selectedSide == 1);
    }

    return Scaffold(
      body: WTESafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.getWhatToEatBackground(),
                ),
                child: InkWell(
                  onTap: () {
                    _onSideSelected(1);
                  },
                  splashColor: AppColors.splashColor,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.restaurant_sharp,
                          size: 36,
                          color: AppColors.textPrimaryColor,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 3,
                              color: Color.fromARGB(140, 110, 110, 110),
                            ),
                          ],
                        ),
                        Text(
                          'What',
                          style: TextStyle(
                            fontSize: 36,
                            color: AppColors.textPrimaryColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 3,
                                color: Color.fromARGB(140, 110, 110, 110),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'to Eat',
                          style: TextStyle(
                            fontSize: 36,
                            color: AppColors.textPrimaryColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 3,
                                color: Color.fromARGB(140, 110, 110, 110),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.getWhereToEatBackground(),
                ),
                child: InkWell(
                  onTap: () {
                    _onSideSelected(2);
                  },
                  splashColor: AppColors.splashColor,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 36,
                          color: AppColors.textPrimaryColor,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 3,
                              color: Color.fromARGB(140, 110, 110, 110),
                            ),
                          ],
                        ),
                        Text(
                          'Where',
                          style: TextStyle(
                            fontSize: 36,
                            color: AppColors.textPrimaryColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 3,
                                color: Color.fromARGB(140, 110, 110, 110),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'to Eat',
                          style: TextStyle(
                            fontSize: 36,
                            color: AppColors.textPrimaryColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 3,
                                color: Color.fromARGB(140, 110, 110, 110),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
