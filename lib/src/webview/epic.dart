import 'dart:async';

import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/client/actions.dart';
import 'package:linkedin_login/src/server/actions.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> _matchToRedirectionUrlEpic(Graph graph) => (
      Stream<dynamic> actions,
      EpicStore<AppState> store,
    ) {
      return actions
          .whereType<DirectionUrlMatch>()
          .switchMap(_urlMatchToDirection);
    };

Stream<dynamic> _urlMatchToDirection(DirectionUrlMatch action) async* {
  if (action.widgetType == WidgetType.fullProfile) {
    yield FetchAccessCode(action.url);
  } else {
    yield FetchAuthCode(action.url);
  }

  yield DirectionUrlMatchSucceededAction(action.url);
}

Epic<AppState> webViewEpics(Graph graph) => combineEpics<AppState>(
      [
        _matchToRedirectionUrlEpic(graph),
      ],
    );
