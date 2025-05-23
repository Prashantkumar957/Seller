//TODO:: Due to null safety (Chart plugin is not support null safety). But you can use if you are not enable null safety

/*
* File : Stack Bar
* Version : 1.0.0
* */

//
//
//
// import 'package:seller/app_notifier.dart';
// import 'package:charts_flutter/flutter.dart';
// import 'package:flutter/material.dart' as Material;
// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
//
//
// import '../../../app_theme.dart';
//
// class StackBarChartWidget extends StatefulWidget {
//   @override
//   _StackBarChartWidgetState createState() => _StackBarChartWidgetState();
// }
//
// class _StackBarChartWidgetState extends State<StackBarChartWidget> {
//
//   late Material.ThemeData themeData;
//
//   @override
//   Widget build(BuildContext context) {
//     themeData = Theme.of(context);
//     return Consumer<AppThemeNotifier>(
//       builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
//         return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
//             home: Scaffold(
//                 appBar: AppBar(
//                   leading: IconButton(
//                     onPressed: () => Navigator.of(context).pop(), icon: Icon(MdiIcons.chevronLeft),
//                   ),
//                   title: Text("Stack Chart",
//                       style: AppTheme.getTextStyle(themeData.textTheme.headline6,fontWeight: 600)),
//                 ),
//                 body: Container(
//                     padding: Material.EdgeInsets.all(32),
//                     color: themeData.backgroundColor,
//                     child: Center(
//                       child: StackedBarChart.withSampleData(),
//                     ))));
//       },
//     );
//   }
// }
//
// class StackedBarChart extends StatelessWidget {
//   final List<charts.Series<dynamic, String>> seriesList;
//   final bool animate;
//
//   StackedBarChart(this.seriesList, {required this.animate});
//
//   factory StackedBarChart.withSampleData() {
//     return new StackedBarChart(
//       _createSampleData(),
//       animate: true,
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     Material.ThemeData themeData = Theme.of(context);
//     return new charts.BarChart(
//       seriesList,
//       animate: animate,
//       barGroupingType: charts.BarGroupingType.stacked,
//
//       domainAxis: charts.OrdinalAxisSpec(renderSpec: SmallTickRendererSpec(labelStyle: TextStyleSpec(
//         color: Color(r: themeData.colorScheme.onBackground.red,g: themeData.colorScheme.onBackground.green,b: themeData.colorScheme.onBackground.blue,),
//       ))),
//       primaryMeasureAxis: charts.NumericAxisSpec(renderSpec: SmallTickRendererSpec(labelStyle: TextStyleSpec(
//           color: Color(r: themeData.colorScheme.onBackground.red,g: themeData.colorScheme.onBackground.green,b: themeData.colorScheme.onBackground.blue,)
//       ))),
//
//
//     );
//   }
//
//   static List<charts.Series<OrdinalSales, String>> _createSampleData() {
//     final desktopSalesData = [
//       new OrdinalSales('2014', 5),
//       new OrdinalSales('2015', 25),
//       new OrdinalSales('2016', 100),
//       new OrdinalSales('2017', 75),
//     ];
//
//     final tableSalesData = [
//       new OrdinalSales('2014', 25),
//       new OrdinalSales('2015', 50),
//       new OrdinalSales('2016', 10),
//       new OrdinalSales('2017', 20),
//     ];
//
//     final mobileSalesData = [
//       new OrdinalSales('2014', 10),
//       new OrdinalSales('2015', 15),
//       new OrdinalSales('2016', 50),
//       new OrdinalSales('2017', 45),
//     ];
//
//     return [
//       new charts.Series<OrdinalSales, String>(
//         id: 'Desktop',
//         domainFn: (OrdinalSales sales, _) => sales.year,
//         measureFn: (OrdinalSales sales, _) => sales.sales,
//         data: desktopSalesData,
//       ),
//       new charts.Series<OrdinalSales, String>(
//         id: 'Tablet',
//         domainFn: (OrdinalSales sales, _) => sales.year,
//         measureFn: (OrdinalSales sales, _) => sales.sales,
//         data: tableSalesData,
//       ),
//       new charts.Series<OrdinalSales, String>(
//         id: 'Mobile',
//         domainFn: (OrdinalSales sales, _) => sales.year,
//         measureFn: (OrdinalSales sales, _) => sales.sales,
//         data: mobileSalesData,
//       ),
//     ];
//   }
// }
//
// class OrdinalSales {
//   final String year;
//   final int sales;
//
//   OrdinalSales(this.year, this.sales);
// }
