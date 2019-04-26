import 'package:flutter/material.dart';
import 'package:stop_watch/StopWatch.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StopWatch',
      home: StopWatch(),
    )
  );
}