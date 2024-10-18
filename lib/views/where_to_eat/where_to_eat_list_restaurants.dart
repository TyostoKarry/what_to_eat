import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_to_eat/models/where_to_eat_model.dart';

import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_no_restaurants.dart';
import 'package:what_to_eat/widgets/wte_text.dart';
import 'package:what_to_eat/widgets/wte_view_title.dart';

class WhereToEatListRestaurants extends StatelessWidget {
  final Set<String> selected;
  final double currentRange;
  final String? selectedCuisine;

  const WhereToEatListRestaurants(
      {super.key,
      required this.selected,
      required this.currentRange,
      required this.selectedCuisine});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WhereToEatModel>(context);

    List<dynamic> restaurants = model.filterAnenity(selected);
    restaurants = model.filterCuisine(restaurants, selectedCuisine);
    restaurants =
        model.filterDistanceWithoutPosition(restaurants, currentRange.toInt());

    bool hasRestaurants = restaurants.isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasRestaurants) ...[
          WTEViewTitle(titleText: "Restaurants Near You"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  var tags = restaurants[index]['tags'];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                    decoration: BoxDecoration(
                      gradient: AppColors.getWhereToEatResultBackground(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: WTEText(
                            text: tags['name'],
                            color: AppColors.textPrimaryColor,
                            fontSize: 20,
                            minFontSize: 20,
                            fontWeight: FontWeight.bold,
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(height: 5),
                        if (tags['distance'] != null) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.map_outlined,
                                color: AppColors.textPrimaryColor,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 3,
                                    color: Color.fromARGB(140, 110, 110, 110),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5),
                              WTEText(
                                text: 'Distance:',
                                color: AppColors.textPrimaryColor,
                                fontSize: 20,
                                minFontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(width: 10),
                              WTEText(
                                text: tags['distance'] > 1000
                                    ? '${(tags['distance'] / 1000).toStringAsFixed(2)} km'
                                    : '${tags['distance'].toInt()} m',
                                color: AppColors.textPrimaryColor,
                                fontSize: 20,
                                minFontSize: 18,
                                maxLines: 4,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 5),
                        if (tags['cuisine'] != null) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.flatware,
                                color: AppColors.textPrimaryColor,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 3,
                                    color: Color.fromARGB(140, 110, 110, 110),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              WTEText(
                                text: 'Cuisine:',
                                color: AppColors.textPrimaryColor,
                                fontSize: 20,
                                minFontSize: 20,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: WTEText(
                                  text: tags['cuisine']
                                      .toString()
                                      .split(';')
                                      .map((e) => e.trim().replaceAll('_', ' '))
                                      .toList()
                                      .join(", "),
                                  color: AppColors.textPrimaryColor,
                                  fontSize: 20,
                                  minFontSize: 18,
                                  maxLines: 4,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ] else
          WhereToEatNoRestaurants()
      ],
    );
  }
}
