import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/widgets/wte_text.dart';

class WTEViewTitle extends StatelessWidget {
  final String titleText;
  final EdgeInsets padding;

  const WTEViewTitle({
    Key? key,
    required this.titleText,
    this.padding = const EdgeInsets.only(top: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: WTEText(
        text: titleText,
        color: AppColors.textPrimaryColor,
        shadowColor: Color.fromARGB(66, 0, 0, 0),
        fontSize: 32,
        minFontSize: 16,
        fontWeight: FontWeight.bold,
        maxLines: 2,
      ),
    );
  }
}
