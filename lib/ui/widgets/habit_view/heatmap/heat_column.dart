import 'package:flutter/material.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/widgets/habit_view/heatmap/heat_box.dart';

class HeatColumn extends StatelessWidget {
  final String label;
  final List<Color> colors;
  const HeatColumn({
    Key? key,
    required this.label,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        children: [
          SizedBox(
            width: 22,
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              reverse: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                return HeatBox(
                  color: colors[colors.length - index - 1],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 22,
              child: Text(
                label,
                style: textCaption2.copyWith(color: myGrey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
