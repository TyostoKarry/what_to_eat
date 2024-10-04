import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:what_to_eat/components/wte_button.dart';
import 'package:what_to_eat/components/wte_text.dart';
import 'package:what_to_eat/models/where_to_eat_model.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhereToEatResult extends StatelessWidget {
  final List<dynamic> restaurants;
  const WhereToEatResult({Key? key, required this.restaurants});

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

      if (tags['addr:postcode'] != null) {
        address.write(", ${tags['addr:postcode']}");
      }

      return address.toString();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WhereToEatModel>(context, listen: false);
    final tags = restaurants[model.resultIndex]['tags'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WTEText(
          text: tags['name'],
          color: AppColors.textPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        if (buildAddress(tags) != null)
          WTEText(
            text: buildAddress(tags)!,
            color: AppColors.textPrimaryColor,
          ),
        if (tags['cuisine'] != null)
          WTEText(
            text: tags['cuisine']
                .toString()
                .split(';')
                .map((e) => e.trim())
                .toList()
                .join(", "),
            color: AppColors.textPrimaryColor,
          ),
        if (tags['opening_hours'] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: tags['opening_hours']
                .toString()
                .split(';')
                .map((e) => e.trim())
                .map((hours) {
              return WTEText(
                text: hours,
                color: AppColors.textPrimaryColor,
              );
            }).toList(),
          ),
        if (tags['phone'] != null)
          WTEText(
            text: tags['phone'],
            color: AppColors.textPrimaryColor,
          ),
        if (tags['website'] != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: WTEButton(
              text: "Visit Restaurants Website",
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
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: WTEButton(
              text: "Search The Restaurant On Google",
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
    );
  }
}
