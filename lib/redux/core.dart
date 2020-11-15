import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/redux/epics.dart';
import 'package:linkedin_login/src/client/reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

AppState reducer(AppState state, dynamic action) {
  return AppState(
    linkedInUserState: linkedInClientReducer(state.linkedInUserState, action),
  );
}

@immutable
class LinkedInStore {
  const LinkedInStore({
    @required this.store,
  }) : assert(store != null);

  factory LinkedInStore.inject() {
    return LinkedInStore(
      store: Store<AppState>(
        reducer,
        initialState: _injectState(),
        middleware: [
          EpicMiddleware<AppState>(epics()),
        ],
      ),
    );
  }

  static AppState _injectState() {
    return AppState.initialState();
  }

  final Store<AppState> store;

  Future dispatchInitial() async {}
}

String _actionFormatter(
  dynamic state,
  dynamic action,
  DateTime timestamp,
) =>
    'Action: $action';
