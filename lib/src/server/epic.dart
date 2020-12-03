import 'dart:async';

import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/server/actions.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> _fetchAuthTokenEpic(Graph graph) => (
      Stream<dynamic> actions,
      EpicStore<AppState> store,
    ) {
      return actions.whereType<FetchAuthCode>().switchMap(
            (action) => _fetchAuthToken(
              action,
              graph.authorizationRepository,
              graph.linkedInConfiguration,
            ),
          );
    };

Stream<dynamic> _fetchAuthToken(
    FetchAuthCode action,
  AuthorizationRepository authRepo,
  Config configuration,
) async* {
  try {
    log('LinkedInAuth-steps: Fetching authorization code...');

    final authorizationCodeResponse = authRepo.fetchAuthorizationCode(
      redirectedUrl: action.url,
      clientState: configuration.state,
    );

    yield FetchAuthCodeSucceededAction(authorizationCodeResponse);
    log('LinkedInAuth-steps: Fetching authorization code... DONE, isEmpty: '
        '${authorizationCodeResponse.code.isEmpty}');
  } on Exception catch (e, s) {
    logError('Unable to fetch auth token', error: e, stackTrace: s);
    yield FetchAuthCodeFailedAction(e);
  }
}

Epic<AppState> serverEpics(Graph graph) => combineEpics<AppState>([
      _fetchAuthTokenEpic(graph),
    ]);
