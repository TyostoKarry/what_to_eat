import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:what_to_eat/components/wte_text.dart';
import 'package:what_to_eat/theme/app_colors.dart';

class WhereToEatInitial extends StatelessWidget {
  const WhereToEatInitial({super.key});

  void _launchOpenStreetMapCopyright() async {
    final Uri searchUrl = Uri.parse('https://www.openstreetmap.org/copyright');
    if (!await launchUrl(
      searchUrl,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $searchUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 60,
              color: AppColors.textPrimaryColor,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  color: Color.fromARGB(140, 110, 110, 110),
                ),
              ],
            ),
            Icon(
              Icons.storefront,
              size: 60,
              color: AppColors.textPrimaryColor,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 3,
                  color: Color.fromARGB(140, 110, 110, 110),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        WTEText(
          text: "Search For",
          color: AppColors.textPrimaryColor,
        ),
        WTEText(
          text: "Restaurants Near You",
          color: AppColors.textPrimaryColor,
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: _launchOpenStreetMapCopyright,
          child: const WTEText(
              text: "Map data from OpenStreetMap",
              color: AppColors.textPrimaryColor,
              fontSize: 12,
              minFontSize: 12,
              textDecoration: TextDecoration.underline),
        ),
        WTEText(
          text: "Providing real-time location-based restaurant data",
          color: AppColors.textPrimaryColor,
          fontSize: 12,
          minFontSize: 12,
        ),
      ],
    );
  }
}
