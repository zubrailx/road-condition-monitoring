import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/state/user_accelerometer.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}

class AccelerometerWidget extends StatelessWidget {
  static const xColor = Colors.red;
  static const yColor = Colors.green;
  static const zColor = Colors.blue;

  const AccelerometerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("Accelerometer", style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 10),
        const AccelerometerChartWidget(),
        const SizedBox(height: 5),
        const AccelerometerValuesWidget()
      ],
    );
  }
}

class AccelerometerChartWidget extends StatelessWidget {
  const AccelerometerChartWidget({
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
    final data = <AccelerometerData>[
      AccelerometerData(
          time: time.add(Duration(seconds: 1)), x: 0, y: 0.2, z: -0.2, ms: 20),
      AccelerometerData(
          time: time.add(Duration(seconds: 2)),
          x: 0.3,
          y: -0.2,
          z: -0.5,
          ms: 20),
      AccelerometerData(
          time: time.add(Duration(seconds: 3)),
          x: 0.1,
          y: 0.5,
          z: -0.3,
          ms: 20),
      AccelerometerData(
          time: time.add(Duration(seconds: 6)),
          x: 0.5,
          y: 0.6,
          z: -0.7,
          ms: 20),
      AccelerometerData(
          time: time.add(Duration(seconds: 7)),
          x: -0.2,
          y: 0.8,
          z: -0.4,
          ms: 20),
      AccelerometerData(
          time: time.add(Duration(seconds: 9)), x: 0.4, y: 2, z: 1, ms: 20),
    ];
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: UsedColors.gray.value,
      ),
      child: SfCartesianChart(
          primaryXAxis: DateTimeAxis(),
          series: <LineSeries<AccelerometerData, DateTime>>[
            LineSeries<AccelerometerData, DateTime>(
                dataSource: data,
                animationDuration: 0,
                color: xColor,
                xValueMapper: (AccelerometerData data, _) => data.time,
                yValueMapper: (AccelerometerData data, _) => data.x),
            LineSeries<AccelerometerData, DateTime>(
                dataSource: data,
                animationDuration: 0,
                color: yColor,
                xValueMapper: (AccelerometerData data, _) => data.time,
                yValueMapper: (AccelerometerData data, _) => data.y),
            LineSeries<AccelerometerData, DateTime>(
                // Bind data source
                dataSource: data,
                animationDuration: 0,
                color: zColor,
                xValueMapper: (AccelerometerData data, _) => data.time,
                yValueMapper: (AccelerometerData data, _) => data.z),
          ]),
    );
  }
}

class AccelerometerValuesWidget extends StatelessWidget {
  const AccelerometerValuesWidget({
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
    final model = context.watch<UserAccelerometerState>();

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
