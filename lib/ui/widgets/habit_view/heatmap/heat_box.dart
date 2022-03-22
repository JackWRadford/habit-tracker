import 'package:flutter/material.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:provider/provider.dart';

class HeatBox extends StatelessWidget {
  final Color color;
  const HeatBox({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: SizedBox(
        width: 18,
        height: 18,
        child: Container(
          decoration: BoxDecoration(
            color: (color != Colors.transparent)
                ? color
                : (Provider.of<ThemeNotifier>(context).getIsDarkMode())
                    ? darkBG
                    : lightBG,
            border: Border.all(
              width: 0,
              color: Colors.transparent,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}
