import 'dart:async';

import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/repository.dart';
import 'package:linkedin_login/src/server/actions.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> _fetchAuthTokenEpic() => (
      Stream<dynamic> actions,
      EpicStore<AppState> store,
    ) {
      return actions
          .whereType<DirectionUrlMatchSucceededAction>()
          .switchMap(_fetchAuthToken);
    };

Stream<dynamic> _fetchAuthToken(
  DirectionUrlMatchSucceededAction action,
) async* {
  try {
    final authorizationCodeResponse = await LinkedInRepository(
      redirectionUrl: action.url,
      clientId: action.configuration.clientId,
    ).fetchWithAuthCode();

    yield FetchAuthCodeSucceededAction(authorizationCodeResponse);
  } on Exception catch (e) {
    yield FetchAuthCodeFailedAction(e);
  }
}

Epic<AppState> serverEpics() => combineEpics<AppState>([
      _fetchAuthTokenEpic(),
    ]);
