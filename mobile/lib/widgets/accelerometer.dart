import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/entities/accelerometer.dart';
import 'package:mobile/state/accelerometer_buffer.dart';
import 'package:mobile/state/accelerometer.dart';
import 'package:mobile/state/chart.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

class AccelerometerChartWidget extends StatefulWidget {
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
  State<StatefulWidget> createState() {
    return _AccelerometerChartWidgetState();
  }

}

class _AccelerometerChartWidgetState extends State<AccelerometerChartWidget> {
  final double animationDuration = 0;

  @override
  Widget build(BuildContext context) {
    final signal = context.watch<ChartState>();
    final state = context.read<AccelerometerBufferState>();
    final data = state.records;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: UsedColors.gray.value,
      ),
      child: SfCartesianChart(
          primaryXAxis: const DateTimeAxis(),
          series: <FastLineSeries<AccelerometerData, DateTime>>[
            FastLineSeries<AccelerometerData, DateTime>(
                dataSource: data,
                animationDuration: animationDuration,
                color: widget.xColor,
                xValueMapper: (AccelerometerData data, _) => data.time,
                yValueMapper: (AccelerometerData data, _) => data.x),
            FastLineSeries<AccelerometerData, DateTime>(
                dataSource: data,
                animationDuration: animationDuration,
                color: widget.yColor,
                xValueMapper: (AccelerometerData data, _) => data.time,
                yValueMapper: (AccelerometerData data, _) => data.y),
            FastLineSeries<AccelerometerData, DateTime>(
                dataSource: data,
                animationDuration: animationDuration,
                color: widget.zColor,
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
