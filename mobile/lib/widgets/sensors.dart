import 'package:flutter/material.dart';
import 'package:mobile/app/theme.dart';

class SensorsWidget extends StatefulWidget {
  const SensorsWidget({super.key});

  @override
  State<StatefulWidget> createState() => _SensorsWidgetState();

}

class _SensorsWidgetState extends State<SensorsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccelerometerWidget(),
          SizedBox(height: 16),
          GyroscopeWidget(),
          SizedBox(height: 16),
          GPSWidget()
        ],
      )
    );
  }
}

class AccelerometerWidget extends StatefulWidget {
  const AccelerometerWidget({super.key});

  @override
  State createState() {
    return _AccelerometerWidgetState();
  }
}

class _AccelerometerWidgetState extends State<AccelerometerWidget> {

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
        Container(height: 200, decoration: BoxDecoration(
          color: UsedColors.gray.value,
        ),),
        const SizedBox(height: 5),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text("label1"),
                SizedBox(width: 10),
                Text("value1"),
              ]
            ),
            Row(
                children: [
                  Text("label2"),
                  SizedBox(width: 10),
                  Text("value2"),
                ]
            ),
            Row(
                children: [
                  Text("label3"),
                  SizedBox(width: 10),
                  Text("value3"),
                ]
            ),
          ]
        )
      ],
    );
  }
}


class GyroscopeWidget extends StatefulWidget {
  const GyroscopeWidget({super.key});


  @override
  State createState() {
    return _GyroscopeWidgetState();
  }
}

class _GyroscopeWidgetState extends State<GyroscopeWidget> {

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
        Container(height: 200, decoration: BoxDecoration(
          color: UsedColors.gray.value,
        ),),
        const SizedBox(height: 5),
        const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    Text("label1"),
                    SizedBox(width: 10),
                    Text("value1"),
                  ]
              ),
              Row(
                  children: [
                    Text("label2"),
                    SizedBox(width: 10),
                    Text("value2"),
                  ]
              ),
              Row(
                  children: [
                    Text("label3"),
                    SizedBox(width: 10),
                    Text("value3"),
                  ]
              ),
            ]
        )
      ],
    );  }
}

class GPSWidget extends StatefulWidget {

  @override
  State createState() {
    return _GPSWidgetState();
  }
}

class _GPSWidgetState extends State<GPSWidget> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("GPS", style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 10),
        const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                  children: [
                    Text("label1"),
                    SizedBox(width: 10),
                    Text("value1"),
                  ]
              ),
              Row(
                  children: [
                    Text("label2"),
                    SizedBox(width: 10),
                    Text("value2"),
                  ]
              ),
            ]
        )
      ],
    );
  }
}
