import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_tracker/core/enums/chart_period.dart';
import 'package:habit_tracker/core/models/habit.dart';
import 'package:habit_tracker/core/providers/analytics_model.dart';
import 'package:habit_tracker/core/providers/home_model.dart';
import 'package:habit_tracker/core/providers/theme_notifier.dart';
import 'package:habit_tracker/ui/shared/app_colours.dart';
import 'package:habit_tracker/ui/shared/app_text_styles.dart';
import 'package:habit_tracker/ui/shared/app_ui_sizes.dart';
import 'package:habit_tracker/ui/shared/app_ui_spacing.dart';
import 'package:provider/provider.dart';

/// Chart showing percentage done over time for [habit]
class ChartSection extends StatelessWidget {
  final Habit habit;
  const ChartSection({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<ChartPeriod, String> _dropDownMap = {
      ChartPeriod.year: AppLocalizations.of(context)!.year,
      ChartPeriod.month: AppLocalizations.of(context)!.month,
      ChartPeriod.week: AppLocalizations.of(context)!.week,
    };
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(mediumRadius))),
      child: Padding(
        padding: const EdgeInsets.all(mediumPadding),
        child: Column(
          children: [
            // Chart title and time period select
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.progress,
                    style: textCallout),
                DropdownButton(
                  enableFeedback: true,
                  alignment: Alignment.centerRight,
                  iconEnabledColor: myGrey,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(smallRadius)),
                  isDense: true,
                  style: textCaption1.copyWith(color: myGrey),
                  underline: Container(),
                  value: habit.chartPeriod,
                  items: <ChartPeriod>[
                    ChartPeriod.year,
                    ChartPeriod.month,
                    ChartPeriod.week
                  ].map<DropdownMenuItem<ChartPeriod>>((ChartPeriod value) {
                    return DropdownMenuItem<ChartPeriod>(
                      value: value,
                      child: Text(
                        _dropDownMap[value]!,
                        style: textCaption1,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    habit.chartPeriod = value as ChartPeriod;
                    Provider.of<HomeModel>(context, listen: false)
                        .updateHabit(habit);
                  },
                ),
              ],
            ),
            UIHelper.verticalSpaceMedium(),
            UIHelper.verticalSpaceSmall(),
            // Percentage done over time chart
            SizedBox(
              height: 200,
              child: FutureBuilder<List<dynamic>>(
                  initialData:
                      Provider.of<AnalyticsModel>(context, listen: false)
                          .getInitChartData(),
                  future:
                      Provider.of<AnalyticsModel>(context).getChartData(habit),
                  builder: (context, snapshot) {
                    return LineChart(mainData(snapshot.data, context),
                        swapAnimationDuration: Duration.zero);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData mainData(List<dynamic>? chartData, BuildContext ctx) {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 20,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: myGrey.withOpacity(0.1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 10,
          interval: 1,
          getTextStyles: (context, value) =>
              textCaption2.copyWith(color: myGrey),
          getTitles: (value) {
            if (chartData != null) {
              return chartData[1][value.toInt()].toString();
            } else {
              return '';
            }
          },
          margin: 14,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) =>
              textCaption2.copyWith(color: myGrey),
          getTitles: (value) {
            switch (value.toInt()) {
              case 20:
                return '20%';
              case 40:
                return '40%';
              case 60:
                return '60%';
              case 80:
                return '80%';
              case 100:
                return '100%';
            }
            return '';
          },
          reservedSize: 30,
          margin: 6,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.symmetric(
            horizontal: BorderSide(color: myGrey.withOpacity(0.1), width: 1)),
      ),
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: (chartData != null) ? chartData[0] : null,
          isCurved: false,
          colors: [habit.color],
          barWidth: 3,
          isStrokeCapRound: false,
          dotData: FlDotData(
            show: true,
            getDotPainter: (p0, p1, p2, p3) {
              return FlDotCirclePainter(
                  radius: 3,
                  color: habit.color,
                  strokeWidth: 2,
                  strokeColor: Provider.of<ThemeNotifier>(ctx, listen: false)
                      .getCardColor());
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [habit.color.withOpacity(0.1)],
          ),
        ),
      ],
    );
  }
}
