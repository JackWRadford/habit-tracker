import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/models/heat_col.dart';
import 'package:habit_tracker/core/providers/analytics_model.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:habit_tracker/ui/widgets/habit_view/heatmap/heat_box.dart';
import 'package:habit_tracker/ui/widgets/habit_view/heatmap/heat_column.dart';
import 'package:provider/provider.dart';

class HeatMapSection extends StatelessWidget {
  final Habit h;
  const HeatMapSection({Key? key, required this.h}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(smallRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          0,
          mediumPadding,
          mediumPadding - tinyPadding,
          mediumPadding - tinyPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //title
            Padding(
              padding: const EdgeInsets.only(left: mediumPadding),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.heatmap,
                      style: textCallout),
                  Row(
                    children: [
                      HeatBox(color: h.color),
                      UIHelper.horizontalSpaceVerySmall(),
                      Text(AppLocalizations.of(context)!.done,
                          style: textCaption2.copyWith(color: myGrey)),
                      UIHelper.horizontalSpaceSmall(),
                      HeatBox(color: h.color.withOpacity(0.2)),
                      UIHelper.horizontalSpaceVerySmall(),
                      Text(AppLocalizations.of(context)!.required,
                          style: textCaption2.copyWith(color: myGrey)),
                    ],
                  )
                ],
              ),
            ),
            UIHelper.verticalSpaceSmall(),
            //heat map
            SizedBox(
              height: 170,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    // tileMode: TileMode.mirror,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                    ],
                    stops: [
                      0.85,
                      0.95,
                    ],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstOut,
                child: FutureBuilder<List<HeatColData>>(
                    initialData: const [],
                    future: Provider.of<AnalyticsModel>(context).getHeatData(h),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(left: largePadding),
                        physics: const AlwaysScrollableScrollPhysics(),
                        reverse: true,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            (snapshot.data != null) ? snapshot.data!.length : 0,
                        itemBuilder: (context, index) {
                          if (snapshot.data != null) {
                            return HeatColumn(
                              label: snapshot.data![index].label,
                              colors: snapshot.data![index].colors,
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
