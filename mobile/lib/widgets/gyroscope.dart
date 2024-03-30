import 'package:flutter/material.dart';
import 'package:mobile/app/theme.dart';
import 'package:mobile/entities/gyroscope.dart';
import 'package:mobile/state/chart.dart';
import 'package:mobile/state/gyroscope.dart';
import 'package:mobile/state/gyroscope_window.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

typedef OnChangeT = void Function(bool?);

class GyroscopeWidget extends StatefulWidget {
  static const xColor = Colors.red;
  static const yColor = Colors.green;
  static const zColor = Colors.blue;

  const GyroscopeWidget({super.key});

  @override
  State createState() {
    return _GyroscopeWidgetState();
  }
}

class _GyroscopeWidgetState extends State<GyroscopeWidget> {
  bool xEnabled = true;
  bool yEnabled = true;
  bool zEnabled = true;

  _xOnChange(_) {
    setState(() {
      xEnabled = !xEnabled;
    });
  }

  _yOnChange(_) {
    setState(() {
      yEnabled = !yEnabled;
    });
  }

  _zOnChange(_) {
    setState(() {
      zEnabled = !zEnabled;
    });
  }

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
        GyroscopeChartWidget(
            xEnabled: xEnabled, yEnabled: yEnabled, zEnabled: zEnabled),
        const SizedBox(height: 5),
        GyroscopeValuesWidget(
            xEnabled: xEnabled,
            yEnabled: yEnabled,
            zEnabled: zEnabled,
            xOnChange: _xOnChange,
            yOnChange: _yOnChange,
            zOnChange: _zOnChange),
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
    this.xEnabled = true,
    this.yEnabled = true,
    this.zEnabled = true,
  });

  final Color xColor;
  final Color yColor;
  final Color zColor;
  final bool xEnabled;
  final bool yEnabled;
  final bool zEnabled;

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
    final data = state.records;

    final series = <CartesianSeries<dynamic, dynamic>>[];
    if (widget.xEnabled) {
      series.add(FastLineSeries<GyroscopeData, DateTime>(
          dataSource: data,
          width: width,
          animationDuration: animationDuration,
          color: widget.xColor,
          xValueMapper: (GyroscopeData data, _) => data.time,
          yValueMapper: (GyroscopeData data, _) => data.x));
    }

    if (widget.yEnabled) {
      series.add(FastLineSeries<GyroscopeData, DateTime>(
          dataSource: data,
          width: width,
          animationDuration: animationDuration,
          color: widget.yColor,
          xValueMapper: (GyroscopeData data, _) => data.time,
          yValueMapper: (GyroscopeData data, _) => data.y));
    }

    if (widget.zEnabled) {
      series.add(FastLineSeries<GyroscopeData, DateTime>(
          dataSource: data,
          width: width,
          animationDuration: animationDuration,
          color: widget.zColor,
          xValueMapper: (GyroscopeData data, _) => data.time,
          yValueMapper: (GyroscopeData data, _) => data.z));
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: UsedColors.gray.value,
      ),
      child:
          SfCartesianChart(primaryXAxis: const DateTimeAxis(), series: series),
    );
  }
}

class GyroscopeValuesWidget extends StatelessWidget {
  const GyroscopeValuesWidget({
    super.key,
    this.xColor = Colors.red,
    this.yColor = Colors.green,
    this.zColor = Colors.blue,
    required this.xEnabled,
    required this.yEnabled,
    required this.zEnabled,
    required this.xOnChange,
    required this.yOnChange,
    required this.zOnChange,
  });

  final Color xColor;
  final Color yColor;
  final Color zColor;
  final bool xEnabled;
  final bool yEnabled;
  final bool zEnabled;
  final OnChangeT xOnChange;
  final OnChangeT yOnChange;
  final OnChangeT zOnChange;

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
        SizedBox(
            width: 32,
            height: 32,
            child: Checkbox(
              activeColor: xColor,
              value: xEnabled,
              onChanged: xOnChange,
            )),
        const Text("X:"),
        const SizedBox(width: 5),
        Text(_valueFormat(model.event?.x) ?? '?'),
      ]),
      Row(children: [
        SizedBox(
            width: 32,
            height: 32,
            child: Checkbox(
              activeColor: yColor,
              value: yEnabled,
              onChanged: yOnChange,
            )),
        const Text("Y:"),
        const SizedBox(width: 5),
        Text(_valueFormat(model.event?.y) ?? '?'),
      ]),
      Row(children: [
        SizedBox(
            width: 32,
            height: 32,
            child: Checkbox(
              activeColor: zColor,
              value: zEnabled,
              onChanged: zOnChange,
            )),
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
