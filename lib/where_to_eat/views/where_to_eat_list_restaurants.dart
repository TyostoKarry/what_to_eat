import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/where_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/where_to_eat/views/where_to_eat_no_restaurants.dart';
import 'package:what_to_eat/where_to_eat/widgets/where_to_eat_restaurant_info.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';
import 'package:what_to_eat/shared/widgets/wte_view_title.dart';

class WhereToEatListRestaurants extends StatefulWidget {
  final Set<String> selected;
  final double currentRange;
  final String? selectedCuisine;

  const WhereToEatListRestaurants({
    super.key,
    required this.selected,
    required this.currentRange,
    required this.selectedCuisine,
  });

  @override
  State<WhereToEatListRestaurants> createState() =>
      _WhereToEatListRestaurantsState();
}

class _WhereToEatListRestaurantsState extends State<WhereToEatListRestaurants> {
  List<dynamic> restaurants = <dynamic>[];
  Set<int> expandedIndexes = <int>{};

  @override
  Widget build(BuildContext context) {
    final WhereToEatModel model = Provider.of<WhereToEatModel>(context);

    restaurants = model.filterAnenity(widget.selected);
    restaurants = model.filterCuisine(restaurants, widget.selectedCuisine);
    restaurants = model.filterDistanceWithoutPosition(
      restaurants,
      widget.currentRange.toInt(),
    );

    bool hasRestaurants = restaurants.isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (hasRestaurants) ...<Widget>[
          const WTEViewTitle(titleText: "Restaurants Near You"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (BuildContext context, int index) {
                  dynamic tags = restaurants[index]['tags'];
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
                    child: TweenAnimationBuilder<EdgeInsets>(
                      tween: Tween<EdgeInsets>(
                        begin: const EdgeInsets.fromLTRB(20, 7, 20, 7),
                        end: isExpanded
                            ? const EdgeInsets.fromLTRB(20, 10, 20, 10)
                            : const EdgeInsets.fromLTRB(20, 7, 20, 7),
                      ),
                      duration: const Duration(milliseconds: 100),
                      builder: (
                        BuildContext context,
                        EdgeInsets padding,
                        Widget? child,
                      ) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 7,
                          ),
                          padding: padding,
                          decoration: BoxDecoration(
                            gradient: AppColors.getWhereToEatResultBackground(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.transparent,
                                  ),
                                  Expanded(
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        begin: 20.0,
                                        end: expandedIndexes.contains(index)
                                            ? 28.0
                                            : 20.0,
                                      ),
                                      duration:
                                          const Duration(milliseconds: 300),
                                      builder: (
                                        BuildContext context,
                                        double fontSize,
                                        Widget? child,
                                      ) {
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
                                  ),
                                  AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: const Icon(
                                      Icons.keyboard_arrow_up,
                                      color: AppColors.textPrimaryColor,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 3,
                                          color: Color.fromARGB(
                                            140,
                                            110,
                                            110,
                                            110,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: 5,
                                  end: isExpanded ? 10 : 5,
                                ),
                                duration: const Duration(milliseconds: 300),
                                builder: (
                                  BuildContext context,
                                  double size,
                                  Widget? child,
                                ) {
                                  return SizedBox(height: size);
                                },
                              ),
                              if (tags['addr:street'] != null)
                                AddressWidget(
                                  index: index,
                                  isExpanded: isExpanded,
                                  tags: tags,
                                  expandedIndexes: expandedIndexes,
                                  restaurants: restaurants,
                                ),
                              if (tags['distance'] != null)
                                DistanceWidget(
                                  index: index,
                                  isExpanded: isExpanded,
                                  tags: tags,
                                  expandedIndexes: expandedIndexes,
                                  restaurants: restaurants,
                                ),
                              if (tags['cuisine'] != null)
                                CuisineWidget(
                                  index: index,
                                  isExpanded: isExpanded,
                                  tags: tags,
                                  expandedIndexes: expandedIndexes,
                                  restaurants: restaurants,
                                ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                child: expandedIndexes.contains(index)
                                    ? expandedRestaurant(index)
                                    : Container(),
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
          const WhereToEatNoRestaurants(),
      ],
    );
  }

  Column expandedRestaurant(int index) {
    return Column(
      children: <Widget>[
        RestaurantDietaryOptionsInfo(restaurant: restaurants[index]),
        RestaurantOpeningHoursInfo(restaurant: restaurants[index]),
        RestaurantContactInfo(restaurant: restaurants[index]),
        RestaurantWebsiteInfo(restaurant: restaurants[index]),
      ],
    );
  }
}

class AddressWidget extends StatelessWidget {
  final int index;
  final bool isExpanded;
  final dynamic tags;
  final Set<int> expandedIndexes;
  final List<dynamic> restaurants;

  const AddressWidget({
    super.key,
    required this.index,
    required this.isExpanded,
    required this.tags,
    required this.expandedIndexes,
    required this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Baseline(
              baseline: 26.5,
              baselineType: TextBaseline.alphabetic,
              child: Icon(
                Icons.location_on,
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
            if (isExpanded) ...<Widget>[
              const SizedBox(width: 10),
              const WTEText(
                text: 'Address',
                color: AppColors.textPrimaryColor,
                fontSize: 20,
                minFontSize: 20,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
              ),
            ],
            if (!isExpanded) ...<Widget>[
              const SizedBox(width: 10),
              Expanded(
                child: RestaurantAddressInfo(
                  restaurant: restaurants[index],
                  includeLabel: false,
                  spaceBelow: 0,
                ),
              ),
            ],
          ],
        ),
        if (!isExpanded) const SizedBox(height: 5),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: expandedIndexes.contains(index)
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: RestaurantAddressInfo(
                    restaurant: restaurants[index],
                    includeLabel: false,
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}

class DistanceWidget extends StatelessWidget {
  final int index;
  final bool isExpanded;
  final dynamic tags;
  final Set<int> expandedIndexes;
  final List<dynamic> restaurants;

  const DistanceWidget({
    super.key,
    required this.index,
    required this.isExpanded,
    required this.tags,
    required this.expandedIndexes,
    required this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const Icon(
              Icons.map_outlined,
              color: AppColors.textPrimaryColor,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  color: Color.fromARGB(140, 110, 110, 110),
                ),
              ],
            ),
            if (isExpanded) ...<Widget>[
              const SizedBox(width: 10),
              const WTEText(
                text: 'Distance',
                color: AppColors.textPrimaryColor,
                fontSize: 20,
                minFontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ],
            if (!isExpanded) ...<Widget>[
              const SizedBox(width: 10),
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
          ],
        ),
        if (!isExpanded) const SizedBox(height: 5),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: expandedIndexes.contains(index)
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: RestaurantDistanceInfo(
                    restaurant: restaurants[index],
                    includeLabel: false,
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}

class CuisineWidget extends StatelessWidget {
  final int index;
  final bool isExpanded;
  final dynamic tags;
  final Set<int> expandedIndexes;
  final List<dynamic> restaurants;

  const CuisineWidget({
    super.key,
    required this.index,
    required this.isExpanded,
    required this.tags,
    required this.expandedIndexes,
    required this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Baseline(
              baseline: 26.5,
              baselineType: TextBaseline.alphabetic,
              child: Icon(
                Icons.flatware,
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
            if (isExpanded) ...<Widget>[
              const SizedBox(width: 10),
              const WTEText(
                text: 'Cuisine',
                color: AppColors.textPrimaryColor,
                fontSize: 20,
                minFontSize: 20,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
              ),
            ],
            if (!isExpanded) ...<Widget>[
              const SizedBox(width: 10),
              Expanded(
                child: RestaurantCuisineInfo(
                  restaurant: restaurants[index],
                  includeLabel: false,
                  spaceBelow: 0,
                ),
              ),
            ],
          ],
        ),
        if (!isExpanded) const SizedBox(height: 5),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: expandedIndexes.contains(index)
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: RestaurantCuisineInfo(
                    restaurant: restaurants[index],
                    includeLabel: false,
                  ),
                )
              : Container(),
        ),
      ],
    );
  }
}
