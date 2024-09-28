import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';

class WTEViewTitle extends StatelessWidget {
  final String titleText;
  final EdgeInsets padding;

  const WTEViewTitle({
    Key? key,
    required this.titleText,
    this.padding = const EdgeInsets.only(top: 60),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: AutoSizeText(
        titleText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimaryColor,
          shadows: [
            Shadow(
              color: Color.fromARGB(66, 0, 0, 0),
              blurRadius: 3,
              offset: Offset(1, 2),
            ),
          ],
        ),
        maxLines: 2,
        minFontSize: 16,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
