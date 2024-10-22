import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/views/where_to_eat/where_to_eat_no_restaurants.dart';
import 'package:what_to_eat/widgets/where_to_eat/where_to_eat_restaurant_info.dart';
import 'package:what_to_eat/widgets/wte_text.dart';
import 'package:what_to_eat/widgets/wte_view_title.dart';

class WhereToEatListRestaurants extends StatefulWidget {
  final Set<String> selected;
  final double currentRange;
  final String? selectedCuisine;

  const WhereToEatListRestaurants(
      {super.key,
      required this.selected,
      required this.currentRange,
      required this.selectedCuisine});

  @override
  State<WhereToEatListRestaurants> createState() =>
      _WhereToEatListRestaurantsState();
}

class _WhereToEatListRestaurantsState extends State<WhereToEatListRestaurants> {
  List<dynamic> restaurants = [];
  Set<int> expandedIndexes = {};

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WhereToEatModel>(context);

    restaurants = model.filterAnenity(widget.selected);
    restaurants = model.filterCuisine(restaurants, widget.selectedCuisine);
    restaurants = model.filterDistanceWithoutPosition(
        restaurants, widget.currentRange.toInt());

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
                  bool isExpanded = expandedIndexes.contains(index);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (expandedIndexes.contains(index)) {
                          expandedIndexes.remove(index);
                        } else {
                          expandedIndexes.add(index);
                        }
                      });
                    },
                    child: TweenAnimationBuilder(
                      tween: Tween<EdgeInsets>(
                        begin: EdgeInsets.fromLTRB(20, 7, 20, 7),
                        end: isExpanded
                            ? EdgeInsets.fromLTRB(20, 10, 20, 10)
                            : EdgeInsets.fromLTRB(20, 7, 20, 7),
                      ),
                      duration: Duration(milliseconds: 100),
                      builder: (context, padding, child) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                          padding: padding,
                          decoration: BoxDecoration(
                            gradient: AppColors.getWhereToEatResultBackground(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              TweenAnimationBuilder(
                                tween: Tween<double>(
                                  begin: 20.0,
                                  end: expandedIndexes.contains(index)
                                      ? 28.0
                                      : 20.0,
                                ),
                                duration: Duration(milliseconds: 300),
                                builder: (context, fontSize, child) {
                                  return Center(
                                    child: WTEText(
                                      text: tags['name'],
                                      color: AppColors.textPrimaryColor,
                                      fontSize: fontSize,
                                      minFontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      maxLines: 3,
                                    ),
                                  );
                                },
                              ),
                              TweenAnimationBuilder(
                                  tween: Tween<double>(
                                    begin: 5,
                                    end: isExpanded ? 10 : 5,
                                  ),
                                  duration: Duration(milliseconds: 300),
                                  builder: (context, size, child) {
                                    return SizedBox(height: size);
                                  }),
                              AnimatedSize(
                                duration: Duration(milliseconds: 300),
                                child: expandedIndexes.contains(index)
                                    ? expandedRestaurant(index)
                                    : collapsedRestaurant(tags),
                              ),
                            ],
                          ),
                        );
                      },
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

  Column expandedRestaurant(int index) {
    return Column(
      children: [
        RestaurantAddressInfo(restaurant: restaurants[index]),
        RestaurantDistanceInfo(restaurant: restaurants[index]),
        RestaurantCuisineInfo(restaurant: restaurants[index]),
        RestaurantDietaryOptionsInfo(restaurant: restaurants[index]),
        RestaurantOpeningHoursInfo(restaurant: restaurants[index]),
        RestaurantContactInfo(restaurant: restaurants[index]),
        RestaurantWebsiteInfo(restaurant: restaurants[index]),
      ],
    );
  }

  Column collapsedRestaurant(tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }
}
