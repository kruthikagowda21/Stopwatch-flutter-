import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
class StopWatch extends StatefulWidget {
  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  
   final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  final _chartSize = const Size(300.0, 300.0);

  Color labelColor = Colors.black;

  List<CircularStackEntry> _generateChartData(int min, int second) {
    //for seconds
    double temp = second * 0.6;
    double adjustedSeconds = second + temp;

    //for minutes
    double tempmin = min * 0.6;
    double adjustedMinutes = min + tempmin;
    
    Color dialColor = Colors.redAccent;

    labelColor = dialColor;

    List<CircularStackEntry> data = [
      new CircularStackEntry(
          [new CircularSegmentEntry(adjustedSeconds.toDouble(), dialColor)])
    ];

    if (min > 0) {
      labelColor = Colors.blue;
      data.removeAt(0);
      data.add(new CircularStackEntry(
          [new CircularSegmentEntry(adjustedSeconds.toDouble(), dialColor)]));

      data.add(new CircularStackEntry(
          [new CircularSegmentEntry(adjustedMinutes.toDouble(), dialColor)]));
    }
    return data;
  }

  Stopwatch watch = new Stopwatch();
  Timer timer;
  String elapsedTime = '00:00:00';

  updateTime(Timer timer) {
    if (watch.isRunning) {
      var milliseconds = watch.elapsedMilliseconds;
      int hundreds = (milliseconds / 10).truncate();
      int seconds = (hundreds / 60).truncate();
      int minutes = (seconds / 60).truncate();
     
      setState(() {
        elapsedTime = transformMilliseconds(watch.elapsedMilliseconds);

        if (seconds > 59) {
          seconds = seconds - (59 * minutes);
          seconds = seconds - minutes;
        }
        List<CircularStackEntry> data = _generateChartData(minutes, seconds);
        _chartKey.currentState.updateData(data);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
      TextStyle _labelStyle = Theme.of(context)
        .textTheme
        .title
        .merge(new TextStyle(color: labelColor));
    return Scaffold(
      appBar: AppBar(
        title:Text('Stopwatch'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Card(
          elevation: 5.0,
                  child: Column(
            children: <Widget>[
              Container(
                child: new AnimatedCircularChart(
                  key: _chartKey,
                  size: _chartSize,
                  initialChartData: _generateChartData(0, 0),
                  chartType: CircularChartType.Radial,
                  edgeStyle: SegmentEdgeStyle.round,
                  percentageValues: true,
                  holeLabel: elapsedTime,
                  labelStyle: _labelStyle,
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 50.0,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: startWatch,
                    child: Icon(Icons.play_circle_outline),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: stopWatch,
                    child: Icon(Icons.stop),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.blueAccent,
                    onPressed: resetWatch,
                    child: Icon(Icons.refresh),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
}
startWatch() {
    watch.start();
    //setTime();
    timer = new Timer.periodic(new Duration(milliseconds: 100), updateTime);
  }

  stopWatch() {
    watch.stop();
    setTime();
  }

  resetWatch() {
    watch.reset();
    setTime();
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliseconds(timeSoFar);
      print(elapsedTime);
      List<CircularStackEntry> data = _generateChartData(0, 0);
      _chartKey.currentState.updateData(data);
    });
  }

  transformMilliseconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 60).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr:$hundredsStr";
  }
}