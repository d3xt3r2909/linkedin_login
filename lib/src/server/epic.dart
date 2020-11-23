import 'dart:async';

import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/server/actions.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> _fetchAuthTokenEpic(Graph graph) => (
      Stream<dynamic> actions,
      EpicStore<AppState> store,
    ) {
      return actions.whereType<DirectionUrlMatchSucceededAction>().switchMap(
            (action) => _fetchAuthToken(
              action,
              graph.authorizationRepository,
              graph.linkedInConfiguration,
            ),
          );
    };

Stream<dynamic> _fetchAuthToken(
  DirectionUrlMatchSucceededAction action,
  AuthorizationRepository authRepo,
  Config configuration,
) async* {
  try {
    final authorizationCodeResponse = authRepo.fetchAuthorizationCode(
      redirectedUrl: action.url,
      clientState: configuration.state,
    );

    yield FetchAuthCodeSucceededAction(authorizationCodeResponse);
  } on Exception catch (e) {
    yield FetchAuthCodeFailedAction(e);
  }
}

Epic<AppState> serverEpics(Graph graph) => combineEpics<AppState>([
      _fetchAuthTokenEpic(graph),
    ]);
