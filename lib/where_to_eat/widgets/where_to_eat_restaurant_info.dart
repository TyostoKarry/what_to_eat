import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:what_to_eat/shared/theme/app_colors.dart';
import 'package:what_to_eat/shared/widgets/wte_button.dart';
import 'package:what_to_eat/shared/widgets/wte_text.dart';

class RestaurantNameInfo extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantNameInfo({required this.restaurant, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: WTEText(
            text: restaurant['tags']['name'],
            color: AppColors.textPrimaryColor,
            fontSize: 28,
            minFontSize: 28,
            fontWeight: FontWeight.bold,
            maxLines: 3,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class RestaurantAddressInfo extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  final bool includeLabel;
  final double spaceBelow;

  const RestaurantAddressInfo({
    required this.restaurant,
    this.includeLabel = true,
    this.spaceBelow = 15,
    super.key,
  });

  @override
  State<RestaurantAddressInfo> createState() => _RestaurantAddressInfoState();
}

class _RestaurantAddressInfoState extends State<RestaurantAddressInfo> {
  String? buildAddress(Map<String, dynamic> restaurant) {
    StringBuffer address;

    if (restaurant['tags']['addr:street'] != null &&
        restaurant['tags']['addr:housenumber'] != null) {
      address = StringBuffer(
        "${restaurant['tags']['addr:street']} ${restaurant['tags']['addr:housenumber']}",
      );

      if (restaurant['tags']['addr:unit'] != null) {
        address.write(" ${restaurant['tags']['addr:unit']}");
      }

      return address.toString();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (buildAddress(widget.restaurant) == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.includeLabel)
          const Row(
            children: <Widget>[
              Icon(
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
              SizedBox(width: 10),
              WTEText(
                text: 'Address',
                color: AppColors.textPrimaryColor,
                fontSize: 20,
                minFontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        WTEText(
          text: buildAddress(widget.restaurant)!,
          color: AppColors.textPrimaryColor,
          fontSize: 20,
          minFontSize: 18,
          textAlign: TextAlign.left,
        ),
        if (widget.restaurant['tags']['addr:postcode'] != null)
          WTEText(
            text: widget.restaurant['tags']['addr:postcode'],
            color: AppColors.textPrimaryColor,
            fontSize: 20,
            minFontSize: 18,
            textAlign: TextAlign.left,
          ),
        SizedBox(height: widget.spaceBelow),
      ],
    );
  }
}

class RestaurantDistanceInfo extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final bool includeLabel;

  const RestaurantDistanceInfo({
    required this.restaurant,
    this.includeLabel = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (restaurant['tags']['distance'] == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (includeLabel)
          const Row(
            children: <Widget>[
              Icon(
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
              SizedBox(width: 10),
              WTEText(
                text: 'Distance',
                color: AppColors.textPrimaryColor,
                fontSize: 20,
                minFontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        WTEText(
          text: restaurant['tags']['distance'] > 1000
              ? '${(restaurant['tags']['distance'] / 1000).toStringAsFixed(2)} kilometers'
              : '${restaurant['tags']['distance'].toInt()} meters',
          color: AppColors.textPrimaryColor,
          fontSize: 20,
          minFontSize: 18,
          maxLines: 4,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class RestaurantCuisineInfo extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final bool includeLabel;
  final double spaceBelow;

  const RestaurantCuisineInfo({
    required this.restaurant,
    this.includeLabel = true,
    this.spaceBelow = 15,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (restaurant['tags']['cuisine'] == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (includeLabel)
          const Row(
            children: <Widget>[
              Icon(
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
              SizedBox(width: 10),
              WTEText(
                text: 'Cuisine',
                color: AppColors.textPrimaryColor,
                fontSize: 20,
                minFontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        WTEText(
          text: restaurant['tags']['cuisine']
              .toString()
              .split(';')
              .map((String e) => e.trim().replaceAll('_', ' '))
              .toList()
              .join(", "),
          color: AppColors.textPrimaryColor,
          fontSize: 20,
          minFontSize: 18,
          maxLines: 4,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: spaceBelow),
      ],
    );
  }
}

class RestaurantDietaryOptionsInfo extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDietaryOptionsInfo({required this.restaurant, super.key});

  @override
  State<RestaurantDietaryOptionsInfo> createState() =>
      _RestaurantDietaryOptionsInfoState();
}

class _RestaurantDietaryOptionsInfoState
    extends State<RestaurantDietaryOptionsInfo> {
  @override
  Widget build(BuildContext context) {
    if (widget.restaurant['tags']['vegan'].isEmpty &&
        widget.restaurant['tags']['diets'].isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Row(
          children: <Widget>[
            Icon(
              Icons.local_dining,
              color: AppColors.textPrimaryColor,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  color: Color.fromARGB(140, 110, 110, 110),
                ),
              ],
            ),
            SizedBox(width: 10),
            WTEText(
              text: 'Dietary Options',
              color: AppColors.textPrimaryColor,
              fontSize: 20,
              minFontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        if (widget.restaurant['tags']['vegan'].isNotEmpty)
          WTEText(
            text: widget.restaurant['tags']['vegan'].join(", "),
            color: AppColors.textPrimaryColor,
            fontSize: 20,
            minFontSize: 18,
            maxLines: 4,
            textAlign: TextAlign.left,
          ),
        if (widget.restaurant['tags']['diets'].isNotEmpty)
          WTEText(
            text: widget.restaurant['tags']['diets'].join(", "),
            color: AppColors.textPrimaryColor,
            fontSize: 20,
            minFontSize: 18,
            maxLines: 4,
            textAlign: TextAlign.left,
          ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class RestaurantOpeningHoursInfo extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantOpeningHoursInfo({required this.restaurant, super.key});

  @override
  State<RestaurantOpeningHoursInfo> createState() =>
      _RestaurantOpeningHoursInfoState();
}

class _RestaurantOpeningHoursInfoState
    extends State<RestaurantOpeningHoursInfo> {
  List<TableRow> buildOpeningHours(String openingHours) {
    List<String> hours = openingHours.split('; ');

    return hours.map((String line) {
      List<String> dayAndTime = line.split(' ');
      String day = dayAndTime[0].trim();
      String time = dayAndTime.length > 1 ? dayAndTime[1].trim() : 'Closed';

      if (time.toLowerCase() == 'off') {
        time = 'Closed';
      }

      return TableRow(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: WTEText(
              text: day,
              color: AppColors.textPrimaryColor,
              fontSize: 20,
              minFontSize: 12,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: WTEText(
              text: time,
              color: AppColors.textPrimaryColor,
              fontSize: 20,
              minFontSize: 12,
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.restaurant['tags']['opening_hours'] == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Row(
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: AppColors.textPrimaryColor,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  color: Color.fromARGB(140, 110, 110, 110),
                ),
              ],
            ),
            SizedBox(width: 10),
            WTEText(
              text: 'Opening Hours',
              color: AppColors.textPrimaryColor,
              fontSize: 20,
              minFontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        Table(
          defaultColumnWidth: const FixedColumnWidth(150.0),
          children:
              buildOpeningHours(widget.restaurant['tags']['opening_hours']),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class RestaurantContactInfo extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantContactInfo({required this.restaurant, super.key});

  @override
  Widget build(BuildContext context) {
    if (restaurant['tags']['phone'] == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Row(
          children: <Widget>[
            Icon(
              Icons.phone,
              color: AppColors.textPrimaryColor,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  color: Color.fromARGB(140, 110, 110, 110),
                ),
              ],
            ),
            SizedBox(width: 10),
            WTEText(
              text: 'Contact Information',
              color: AppColors.textPrimaryColor,
              fontSize: 20,
              minFontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        WTEText(
          text: restaurant['tags']['phone'],
          color: AppColors.textPrimaryColor,
          fontSize: 20,
          minFontSize: 18,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class RestaurantWebsiteInfo extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantWebsiteInfo({required this.restaurant, super.key});

  Future<void> _launchGoogleSearch(String query) async {
    final Uri searchUrl = Uri.parse(
      "https://www.google.com/search?q=${Uri.encodeComponent(query)}",
    );
    if (!await launchUrl(
      searchUrl,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $searchUrl');
    }
  }

  Future<void> _launchRestaurantWebsite(String url) async {
    final Uri searchUrl = Uri.parse(url);
    if (!await launchUrl(
      searchUrl,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $searchUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (restaurant['tags']['website'] != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
        child: WTEButton(
          text: "Restaurant Website",
          gradient: AppColors.getWhereToEatButtonBackground(),
          textColor: AppColors.textSecondaryColor,
          onTap: () {
            _launchRestaurantWebsite(restaurant['tags']['website']);
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: WTEButton(
        text: "Search on Google",
        gradient: AppColors.getWhereToEatButtonBackground(),
        textColor: AppColors.textSecondaryColor,
        onTap: () {
          _launchGoogleSearch(restaurant['tags']['name']);
        },
      ),
    );
  }
}
