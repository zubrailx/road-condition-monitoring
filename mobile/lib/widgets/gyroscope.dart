import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:mobile/state/gyroscope.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GyroscopeWidget extends StatelessWidget {
  const GyroscopeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("Gyroscope", style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 10),
        const GyroscopeChartWidget(),
        const SizedBox(height: 5),
        const GyroscopeValuesWidget(),
      ],
    );
  }
}

class GyroscopeChartWidget extends StatelessWidget {
  const GyroscopeChartWidget({
    super.key,
    this.xColor = Colors.red,
    this.yColor = Colors.green,
    this.zColor = Colors.blue,
  });

  final Color xColor;
  final Color yColor;
  final Color zColor;

  @override
  Widget build(BuildContext context) {
    final time = DateTime.timestamp();
    final data = <GyroscopeData>[
      GyroscopeData(
          time: time.add(Duration(seconds: 1)), x: 0, y: 0.2, z: -0.2, ms: 20),
      GyroscopeData(
          time: time.add(Duration(seconds: 2)),
          x: 0.3,
          y: -0.2,
          z: -0.5,
          ms: 20),
      GyroscopeData(
          time: time.add(Duration(seconds: 3)),
          x: 0.1,
          y: 0.5,
          z: -0.3,
          ms: 20),
      GyroscopeData(
          time: time.add(Duration(seconds: 6)),
          x: 0.5,
          y: 0.6,
          z: -0.7,
          ms: 20),
      GyroscopeData(
          time: time.add(Duration(seconds: 7)),
          x: -0.2,
          y: 0.8,
          z: -0.4,
          ms: 20),
      GyroscopeData(
          time: time.add(Duration(seconds: 9)), x: 0.4, y: 2, z: 1, ms: 20),
    ];
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: UsedColors.gray.value,
      ),
      child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(),
          series: <LineSeries<GyroscopeData, DateTime>>[
            LineSeries<GyroscopeData, DateTime>(
                dataSource: data,
                animationDuration: 0,
                color: xColor,
                xValueMapper: (GyroscopeData data, _) => data.time,
                yValueMapper: (GyroscopeData data, _) => data.x),
            LineSeries<GyroscopeData, DateTime>(
                dataSource: data,
                animationDuration: 0,
                color: yColor,
                xValueMapper: (GyroscopeData data, _) => data.time,
                yValueMapper: (GyroscopeData data, _) => data.y),
            LineSeries<GyroscopeData, DateTime>(
                // Bind data source
                dataSource: data,
                animationDuration: 0,
                color: zColor,
                xValueMapper: (GyroscopeData data, _) => data.time,
                yValueMapper: (GyroscopeData data, _) => data.z),
          ]),
    );
  }
}

class GyroscopeValuesWidget extends StatelessWidget {
  const GyroscopeValuesWidget({
    super.key,
    this.xColor = Colors.red,
    this.yColor = Colors.green,
    this.zColor = Colors.blue,
  });

  final Color xColor;
  final Color yColor;
  final Color zColor;

  String? _valueFormat(double? v) {
    return v?.toStringAsFixed(2).padRight(8, ' ');
  }

  String? _msFormat(int? v) {
    return v.toString().padRight(3, ' ');
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<GyroscopeState>();

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Row(children: [
        SvgPicture.asset("assets/svg/Line.svg",
            width: 16, colorFilter: ColorFilter.mode(xColor, BlendMode.srcIn)),
        const SizedBox(width: 5),
        const Text("X:"),
        const SizedBox(width: 5),
        Text(_valueFormat(model.event?.x) ?? '?'),
      ]),
      Row(children: [
        SvgPicture.asset("assets/svg/Line.svg",
            width: 16, colorFilter: ColorFilter.mode(yColor, BlendMode.srcIn)),
        const SizedBox(width: 5),
        const Text("Y:"),
        const SizedBox(width: 5),
        Text(_valueFormat(model.event?.y) ?? '?'),
      ]),
      Row(children: [
        SvgPicture.asset("assets/svg/Line.svg",
            width: 16, colorFilter: ColorFilter.mode(zColor, BlendMode.srcIn)),
        const SizedBox(width: 5),
        const Text("Z:"),
        const SizedBox(width: 5),
        Text(_valueFormat(model.event?.z) ?? '?'),
      ]),
      Row(children: [
        const Text("Interval:"),
        const SizedBox(width: 5),
        Text('${_msFormat(model.lastInterval) ?? '?'} ms'),
      ]),
    ]);
  }
}
