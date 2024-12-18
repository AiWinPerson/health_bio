import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../model/eeg_signal.dart';

class EegLineChart extends StatefulWidget {
  const EegLineChart({super.key, required this.eegData,required this.color});
  final List<EegSignal> eegData;
  final Color color;
  @override
  State<EegLineChart> createState() => _EegLineChartState();
}

class _EegLineChartState extends State<EegLineChart> {

  late Timer timer;
  int limitCount = 30;
  late int xValue = limitCount;
  List<EegSignal> graphData = [];

  @override
  void initState() {
    graphData = widget.eegData.sublist(0,limitCount);
    timer = Timer.periodic(const Duration(milliseconds: 4), (timer) {
      if(mounted){
        if(xValue == widget.eegData.length){
          timer.cancel();
        }
        while(graphData.length > limitCount){
          graphData.removeAt(0);
        }
        graphData.add(widget.eegData[xValue]);
        xValue+=1;
        setState(() {});
      }else{
        timer.cancel();
      }
    },);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
                color: widget.color,
                isCurved: true,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: true,color: widget.color.withOpacity(0.2)),
                spots: graphData.map((e) => FlSpot(e.x, e.y)).toList()
            )
          ],
          borderData: FlBorderData(show: false,),
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
        )
    );
  }
}
