import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';

import '../unit/utils/shared_mocks.mocks.dart';

class WidgetTestbed {
  WidgetTestbed({
    this.graph,
  });

  final Graph? graph;

  Widget injectWrap({
    final Widget? child,
    final RouteFactory? routeFactory,
    final Brightness brightness = Brightness.light,
    final bool autoRoute = true,
  }) {
    return InjectorWidget(
      graph: graph ?? MockGraph(),
      child: autoRoute
          ? simpleWrap(
              child: child,
              routeFactory: routeFactory,
            )
          : child!,
    );
  }

  Widget simpleWrap({
    final Widget? child,
    final RouteFactory? routeFactory,
    final Brightness brightness = Brightness.light,
  }) {
    return MaterialApp(
      theme: ThemeData(brightness: brightness),
      localizationsDelegates: const [],
      onGenerateRoute: routeFactory,
      home: child != null ? Material(child: child) : null,
    );
  }

  void increaseScreenSize(final WidgetTester tester) {
    tester.binding.window.physicalSizeTestValue = const Size(30000, 30000);
  }
}
