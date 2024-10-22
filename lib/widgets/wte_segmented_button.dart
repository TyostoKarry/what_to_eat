import 'package:flutter/material.dart';

import 'package:what_to_eat/theme/app_colors.dart';
import 'package:what_to_eat/widgets/wte_text.dart';

class WTESegmentedButton extends StatefulWidget {
  final List<String> options;
  final List<IconData> selectedIcons;
  final List<IconData> unselectedIcons;
  final Set<String> selected;
  final bool multiSelectionEnabled;
  final bool allowEmptySelection;
  final bool isEnabled;
  final void Function(Set<String>) onSelectionChanged;

  const WTESegmentedButton({
    super.key,
    required this.options,
    required this.selectedIcons,
    required this.unselectedIcons,
    required this.selected,
    this.multiSelectionEnabled = false,
    this.allowEmptySelection = false,
    this.isEnabled = true,
    required this.onSelectionChanged,
  });

  @override
  WTESegmentedButtonState createState() => WTESegmentedButtonState();
}

class WTESegmentedButtonState extends State<WTESegmentedButton> {
  late Set<String> selectedOptions;

  @override
  void initState() {
    super.initState();
    if (widget.multiSelectionEnabled) {
      selectedOptions = Set<String>.from(widget.selected);
    }
    if (!widget.multiSelectionEnabled) {
      selectedOptions = <String>{widget.options.first};
    }
  }

  void _toggleSelection(String value) {
    if (!widget.isEnabled) return;
    setState(() {
      if (selectedOptions.contains(value)) {
        if (widget.allowEmptySelection || selectedOptions.length > 1) {
          selectedOptions.remove(value);
        } else if (!widget.allowEmptySelection && selectedOptions.length == 1) {
          int currentIndex = widget.options.indexOf(value);
          int nextIndex = (currentIndex + 1) % widget.options.length;
          selectedOptions.clear();
          selectedOptions.add(widget.options[nextIndex]);
        }
      } else {
        if (!widget.multiSelectionEnabled) {
          selectedOptions.clear();
        }
        selectedOptions.add(value);
      }
      widget.onSelectionChanged(selectedOptions);
    });
  }

  BorderRadius _getBorderRadius(int index, int total) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(8),
        bottomLeft: Radius.circular(8),
      );
    } else if (index == total - 1) {
      return const BorderRadius.only(
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(8),
      );
    }
    return BorderRadius.zero;
  }

  Border _getBorder(int index, int total) {
    if (index == 0) {
      return const Border(
        right: BorderSide(color: AppColors.wheelTextShadowColor),
      );
    } else if (index == total - 1) {
      return const Border();
    }
    return const Border(
      right: BorderSide(color: AppColors.wheelTextShadowColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        children: List.generate(widget.options.length, (index) {
          final String option = widget.options[index];
          final IconData selectedIcon = widget.selectedIcons[index];
          final IconData unselectedIcon = widget.unselectedIcons[index];
          final bool isSelected = selectedOptions.contains(option);
          final int totalOptions = widget.options.length;

          return Expanded(
            child: GestureDetector(
              onTap: widget.isEnabled ? () => _toggleSelection(option) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  gradient: widget.isEnabled
                      ? isSelected
                          ? AppColors.getWhereToEatButtonBackground()
                          : null
                      : null,
                  color: widget.isEnabled
                      ? isSelected
                          ? null
                          : AppColors.whereToEatButtonPrimaryColor
                              .withOpacity(0.8)
                      : isSelected
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                  border: _getBorder(index, totalOptions),
                  borderRadius: _getBorderRadius(index, totalOptions),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? selectedIcon : unselectedIcon,
                      color: AppColors.textSecondaryColor,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 2,
                          color: AppColors.textSecondaryShadowColor,
                        ),
                      ],
                    ),
                    SizedBox(width: 6),
                    WTEText(
                        text: option,
                        color: AppColors.textSecondaryColor,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                        minFontSize: 16,
                        shadowColor: AppColors.textSecondaryShadowColor,
                        offset: const Offset(2, 2)),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
