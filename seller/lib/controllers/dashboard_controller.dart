import 'dart:ui';

import 'package:flutx/flutx.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:seller/theme/constant.dart';
import 'package:seller/widgets/syncfusion/data/charts_sample_data.dart';

class DashboardController extends FxController {
  late List<String> filterTime;
  late String time;
  late TooltipBehavior tooltipBehavior;
  late List<ChartSampleData> chartData, yearly, allTime, monthly, thisWeek;

  late List<Color> chartColorList;

  @override
  void initState() {
    super.initState();
    chartColorList = [
      Constant.softColors.blue.color,
      Constant.softColors.violet.color,
      Constant.softColors.orange.color,
    ];
    filterTime = ["All time", "This Week", "Monthly", "Yearly"];
    time = filterTime.first;
    initChartData();
  }

  initChartData() {
    tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    chartData = <ChartSampleData> [
      ChartSampleData(
        x: '--',
        y: 0,
      ),
      ChartSampleData(
        x: '--',
        y: 0,
      ),
      ChartSampleData(
        x: '--',
        y: 0,
      ),
      ChartSampleData(
        x: '--',
        y: 0,
      ),
      ChartSampleData(
        x: '--',
        y: 0,
      ),
    ];
  }

  void changeFilter(String time) {
    this.time = time;
    switch (time) {
      case 'This Week':
        chartData = thisWeek;
        break;
      case 'Monthly':
        chartData = monthly;
        break;
      case 'Yearly':
      case 'All time':
        chartData = yearly;
        break;
    }
    update();
  }

  @override
  String getTag() {
    return "shopping_login_controller";
  }
}
