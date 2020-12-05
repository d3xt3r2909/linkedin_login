import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';
import 'package:redux/redux.dart';

import '../unit/utils/mocks.dart';

typedef OnReduction = AppState Function(dynamic);

class WidgetTestbed {
  WidgetTestbed({
    this.graph,
    this.store,
    this.onReduction,
  });

  final Graph graph;
  final Store<AppState> store;
  final OnReduction onReduction;

  Store<AppState> _trueStore;

  void flushActions() => _trueStore.dispatch(1);

  void dispatch(dynamic action) {
    _trueStore.dispatch(action);
  }

  Widget reduxWrap({
    Widget child,
    RouteFactory routeFactory,
    Brightness brightness = Brightness.light,
  }) {
    _trueStore = Store<AppState>(
      (AppState state, dynamic action) {
        return onReduction?.call(action) ?? state;
      },
      initialState: store?.state ?? AppState.initialState(),
    );
    return InjectorWidget(
      graph: graph ?? MockGraph(),
      child: StoreProvider<AppState>(
        store: _trueStore,
        child: simpleWrap(
          child: child,
          routeFactory: routeFactory,
          brightness: brightness,
        ),
      ),
    );
  }

  Widget simpleWrap({
    Widget child,
    RouteFactory routeFactory,
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
