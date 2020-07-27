import 'package:flutter/material.dart';

Widget GiveScaffoldCenterText(String x) {
  return Scaffold(
    body: Center(
      child: Text(x),
    ),
  );
}

Widget GiveScaffoldCPI() {
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
