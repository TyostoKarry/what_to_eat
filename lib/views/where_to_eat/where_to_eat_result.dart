import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/components/wte_text.dart';
import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhereToEatResult extends StatefulWidget {
  final List<dynamic> restaurants;

  const WhereToEatResult({Key? key, required this.restaurants})
      : super(key: key);

  @override
  _WhereToEatResultState createState() => _WhereToEatResultState();
}

class _WhereToEatResultState extends State<WhereToEatResult>
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

  Future<void> _launchGoogleSearch(String query) async {
    final Uri searchUrl = Uri.parse(
        "https://www.google.com/search?q=${Uri.encodeComponent(query)}");
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

  String? buildAddress(Map<String, dynamic> tags) {
    if (tags['addr:street'] != null && tags['addr:housenumber'] != null) {
      StringBuffer address =
          StringBuffer("${tags['addr:street']} ${tags['addr:housenumber']}");

      if (tags['addr:unit'] != null) {
        address.write(" ${tags['addr:unit']}");
      }

      return address.toString();
    }
    return null;
  }

  List<TableRow> buildOpeningHours(String openingHours) {
    List<String> hours = openingHours.split('; ');

    return hours.map((line) {
      List<String> dayAndTime = line.split(' ');
      String day = dayAndTime[0].trim();
      String time = dayAndTime.length > 1 ? dayAndTime[1].trim() : 'Closed';

      if (time.toLowerCase() == 'off') {
        time = 'Closed';
      }

      return TableRow(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: WTEText(
              text: day,
              color: AppColors.textPrimaryColor,
              fontSize: 20,
              minFontSize: 18,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: WTEText(
              text: time,
              color: AppColors.textPrimaryColor,
              fontSize: 20,
              minFontSize: 18,
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WhereToEatModel>(context, listen: false);
    final tags = widget.restaurants[model.resultIndex]['tags'];

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
                  Center(
                    child: WTEText(
                      text: tags['name'],
                      color: AppColors.textPrimaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (buildAddress(tags) != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
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
                          text: 'Address',
                          color: AppColors.textPrimaryColor,
                          fontSize: 20,
                          minFontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    WTEText(
                      text: buildAddress(tags)!,
                      color: AppColors.textPrimaryColor,
                      fontSize: 20,
                      minFontSize: 18,
                    ),
                    if (tags['addr:postcode'] != null)
                      WTEText(
                        text: tags['addr:postcode'],
                        color: AppColors.textPrimaryColor,
                        fontSize: 20,
                        minFontSize: 18,
                      ),
                    SizedBox(height: 15),
                  ],
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
                          text: 'Cuisine',
                          color: AppColors.textPrimaryColor,
                          fontSize: 20,
                          minFontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    WTEText(
                      text: tags['cuisine']
                          .toString()
                          .split(';')
                          .map((e) => e.trim())
                          .toList()
                          .join(", "),
                      color: AppColors.textPrimaryColor,
                      fontSize: 20,
                      minFontSize: 18,
                      maxLines: 4,
                    ),
                    SizedBox(height: 15),
                  ],
                  if (tags['opening_hours'] != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
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
                          text: 'Opening Hours',
                          color: AppColors.textPrimaryColor,
                          fontSize: 20,
                          minFontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Table(
                      defaultColumnWidth: FixedColumnWidth(150.0),
                      children: buildOpeningHours(tags['opening_hours']),
                    ),
                    SizedBox(height: 15),
                  ],
                  if (tags['phone'] != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: AppColors.textPrimaryColor,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 3,
                              color: Color.fromARGB(140, 110, 110, 110),
                            )
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
                      text: tags['phone'],
                      color: AppColors.textPrimaryColor,
                      fontSize: 20,
                      minFontSize: 18,
                    ),
                  ],
                  if (tags['website'] != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: WTEButton(
                        text: "Restaurant Website",
                        textColor: AppColors.textSecondaryColor,
                        onTap: () {
                          _launchRestaurantWebsite(tags['website']);
                        },
                        gradientColors: [
                          AppColors.whereToEatButtonPrimaryColor,
                          AppColors.whereToEatButtonSecondaryColor
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: WTEButton(
                        text: "Search on Google",
                        textColor: AppColors.textSecondaryColor,
                        onTap: () {
                          _launchGoogleSearch(tags['name']);
                        },
                        gradientColors: [
                          AppColors.whereToEatButtonPrimaryColor,
                          AppColors.whereToEatButtonSecondaryColor
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
