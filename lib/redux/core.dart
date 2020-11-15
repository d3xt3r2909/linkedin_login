import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/redux/epics.dart';
import 'package:linkedin_login/src/client/reducer.dart';
import 'package:linkedin_login/src/server/reducer.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

AppState reducer(AppState state, dynamic action) {
  return AppState(
    linkedInUserState: linkedInClientReducer(state.linkedInUserState, action),
    userAuthCodeState: linkedInServerReducer(state.userAuthCodeState, action),
  );
}

@immutable
class LinkedInStore {
  const LinkedInStore({
    @required this.store,
    @required this.graph,
  })  : assert(store != null),
        assert(graph != null);

  factory LinkedInStore.inject(Graph graph) {
    return LinkedInStore(
      graph: graph,
      store: Store<AppState>(
        reducer,
        initialState: _injectState(),
        middleware: [
          EpicMiddleware<AppState>(epics(graph)),
        ],
      ),
    );
  }

  static AppState _injectState() {
    return AppState.initialState();
  }

  final Store<AppState> store;
  final Graph graph;

  Future dispatchInitial() async {}
}
