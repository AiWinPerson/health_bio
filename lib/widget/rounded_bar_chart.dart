import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../util/color_set.dart';

class RoundedBarChart extends StatelessWidget {
  const RoundedBarChart({super.key, required this.yData, required this.titles});
  final List<double> yData;
  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
          barGroups: List.generate(yData.length, (index) {
            return BarChartGroupData(x: index,barRods: [
              BarChartRodData(
                  toY: yData[index],
                  width: 22,
                  backDrawRodData: BackgroundBarChartRodData(
                    color: ColorSet.blackOpacity100,
                    toY: 12,
                    show: true,
                  )
              )
            ]);
          },),
          borderData: FlBorderData(show: false,),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getBottomTitlesWidget,
                reservedSize: 38,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: 1,
                  getTitlesWidget:getLeftTitleWidget
              ),
            ),
          )
      ),
      duration: const Duration(milliseconds: 250),
    );
  }

  Widget getBottomTitlesWidget(double index, TitleMeta meta){
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(titles[index.toInt()],style: const TextStyle(
        color: ColorSet.blackOpacity300,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
    );
  }

  Widget getLeftTitleWidget(double index, TitleMeta meta){
    int yValue = index.toInt();
    return index % 3 == 0? SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(yValue.toString(),style: const TextStyle(
        color: Color(0xff7589a2),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
    ) : const SizedBox();
  }

}
