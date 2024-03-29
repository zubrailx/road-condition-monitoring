import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:mobile/state/chart.dart';
import 'package:mobile/state/gyroscope.dart';
import 'package:mobile/state/gyroscope_buffer.dart';
import 'package:mobile/state/gyroscope_window.dart';
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

class GyroscopeChartWidget extends StatefulWidget {
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
  State<StatefulWidget> createState() {
    return _GyroscopeChartWidgetState();
  }
}


class _GyroscopeChartWidgetState extends State<GyroscopeChartWidget> {
  final double animationDuration = 0;
  final double width = 1.5;

  @override
  Widget build(BuildContext context) {
    final signal = context.watch<ChartState>();
    final state = context.read<GyroscopeWindowState>();
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: UsedColors.gray.value,
      ),
      child: SfCartesianChart(
          primaryXAxis: const DateTimeAxis(),
          series: <FastLineSeries<GyroscopeData, DateTime>>[
            FastLineSeries<GyroscopeData, DateTime>(
                width: width,
                dataSource: state.records,
                animationDuration: animationDuration,
                color: widget.xColor,
                xValueMapper: (GyroscopeData data, _) => data.time,
                yValueMapper: (GyroscopeData data, _) => data.x),
            FastLineSeries<GyroscopeData, DateTime>(
                width: width,
                dataSource: state.records,
                animationDuration: animationDuration,
                color: widget.yColor,
                xValueMapper: (GyroscopeData data, _) => data.time,
                yValueMapper: (GyroscopeData data, _) => data.y),
            FastLineSeries<GyroscopeData, DateTime>(
                width: width,
                dataSource: state.records,
                animationDuration: animationDuration,
                color: widget.zColor,
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
