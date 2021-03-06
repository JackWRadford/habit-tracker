import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/providers/add_edit_habit_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:provider/provider.dart';

/// Color select section
class ColorSelect extends StatelessWidget {
  const ColorSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: smallPadding,
          crossAxisCount: 6,
          childAspectRatio: 1.5),
      itemCount: myColors.length,
      itemBuilder: (BuildContext ctx, i) => _ColorOption(color: myColors[i]),
    );
  }
}

/// Color option list item
///
/// Shows and selected given [color]
class _ColorOption extends StatelessWidget {
  final Color color;
  const _ColorOption({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Provider.of<AddEditHabitModel>(context, listen: false)
          .setSelectedColor(color),
      child: Card(
        margin: const EdgeInsets.all(0),
        color: color,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(smallRadius)),
        ),
        child: Center(
          child: (Provider.of<AddEditHabitModel>(context).selectedColor ==
                  color)
              ? const Icon(CupertinoIcons.checkmark_alt, color: Colors.white)
              : Container(),
        ),
      ),
    );
  }
}
