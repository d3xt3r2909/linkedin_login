import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:redux/redux.dart';

typedef OnReduction = AppState Function(dynamic);

class WidgetTestbed {
  WidgetTestbed({
    this.store,
    this.onReduction,
  });

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
    @Deprecated('Please [withPlatform] instead') TargetPlatform platform,
  }) {
    _trueStore = Store<AppState>(
      (AppState state, dynamic action) {
        return onReduction?.call(action) ?? state;
      },
      initialState: store?.state ?? AppState.initialState(),
    );
    return StoreProvider<AppState>(
      store: _trueStore,
      child: simpleWrap(
        child: child,
        routeFactory: routeFactory,
        brightness: brightness,
      ),
    );
  }

  Widget simpleWrap({
    Widget child,
    RouteFactory routeFactory,
    Brightness brightness = Brightness.light,
    @Deprecated('Please [withPlatform] instead') TargetPlatform platform,
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

  @Deprecated('Please [withPlatform] instead')
  void resetPlatform() => debugDefaultTargetPlatformOverride = null;
}
