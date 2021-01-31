import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';

class WidgetTestbed {
  WidgetTestbed({
    this.graph,
  });

  final Graph? graph;

  Widget simpleWrap({
    Widget? child,
    RouteFactory? routeFactory,
    Brightness brightness = Brightness.light,
  }) {
    return MaterialApp(
      theme: ThemeData(brightness: brightness),
      localizationsDelegates: [],
      onGenerateRoute: routeFactory,
      home: child != null ? Material(child: child) : null,
    );
  }

  void increaseScreenSize(WidgetTester tester) {
    tester.binding.window.physicalSizeTestValue = Size(30000, 30000);
  }
}
