import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/widgets/where_to_eat/where_to_eat_restaurant_info.dart';

class WhereToEatResult extends StatefulWidget {
  final List<dynamic> restaurants;

  const WhereToEatResult({super.key, required this.restaurants});

  @override
  WhereToEatResultState createState() => WhereToEatResultState();
}

class WhereToEatResultState extends State<WhereToEatResult>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  double _calculatedHeight = 60.0;
  final GlobalKey _contentKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateContentHeight();
    });
  }

  void _calculateContentHeight() {
    final RenderBox renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox;

    if (renderBox.hasSize) {
      setState(() {
        _calculatedHeight = renderBox.size.height;
        _expanded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WhereToEatModel>(context, listen: false);

    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: _expanded ? _calculatedHeight : 60,
          decoration: BoxDecoration(
            gradient: AppColors.getWhereToEatResultBackground(),
            borderRadius: BorderRadius.circular(_expanded ? 20 : 10),
          ),
          child: SingleChildScrollView(
            child: Padding(
              key: _contentKey,
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: ((60 - model.nameTextHeight) / 2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RestaurantNameInfo(
                      restaurant: widget.restaurants[model.resultIndex]),
                  RestaurantAddressInfo(
                      restaurant: widget.restaurants[model.resultIndex]),
                  RestaurantDistanceInfo(
                      restaurant: widget.restaurants[model.resultIndex]),
                  RestaurantCuisineInfo(
                      restaurant: widget.restaurants[model.resultIndex]),
                  RestaurantDietaryOptionsInfo(
                      restaurant: widget.restaurants[model.resultIndex]),
                  RestaurantOpeningHoursInfo(
                      restaurant: widget.restaurants[model.resultIndex]),
                  RestaurantContactInfo(
                      restaurant: widget.restaurants[model.resultIndex]),
                  RestaurantWebsiteInfo(
                      restaurant: widget.restaurants[model.resultIndex]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
