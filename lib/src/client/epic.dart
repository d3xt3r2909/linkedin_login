import 'dart:async';

import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/client/actions.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> _fetchAccessTokenEpic(Graph graph) => (
      Stream<dynamic> actions,
      EpicStore<AppState> store,
    ) {
      return actions.whereType<DirectionUrlMatchSucceededAction>().switchMap(
            (action) => _fetchAccessTokenUser(
              action,
              graph.authorizationRepository,
              graph.linkedInConfiguration,
            ),
          );
    };

Stream<dynamic> _fetchAccessTokenUser(
  DirectionUrlMatchSucceededAction action,
  AuthorizationRepository authRepo,
  Config configuration,
) async* {
  try {
    final authorizationCodeResponse = await authRepo.fetchAccessTokenCode(
      redirectedUrl: action.url,
      clientId: configuration.clientId,
      clientSecret: configuration.clientSecret,
      clientState: configuration.state,
    );

    yield FetchAccessCodeSucceededAction(authorizationCodeResponse.accessToken);
  } on Exception catch (e, s) {
    logError('Unable to fetch access token code', error: e, stackTrace: s);
    yield FetchAccessCodeFailedAction(e);
  }
}

Epic<AppState> _fetchLinkedUserProfileEpic(Graph graph) => (
      Stream<dynamic> actions,
      EpicStore<AppState> store,
    ) {
      return actions.whereType<FetchAccessCodeSucceededAction>().switchMap(
            (action) => _fetchLinkedInProfile(
              action,
              graph.userRepository,
              graph.linkedInConfiguration,
            ),
          );
    };

Stream<dynamic> _fetchLinkedInProfile(
  FetchAccessCodeSucceededAction action,
  UserRepository userRepo,
  Config configuration,
) async* {
  try {
    final user = await userRepo.fetchFullProfile(
      token: action.token,
      projection: configuration.projection,
    );

    yield FetchLinkedInUserSucceededAction(user);
  } on Exception catch (e, s) {
    logError('Unable to fetch LinkedIn profile', error: e, stackTrace: s);
    yield FetchLinkedInUserFailedAction(e);
  }
}

Epic<AppState> clientEpics(Graph graph) => combineEpics<AppState>([
      _fetchAccessTokenEpic(graph),
      _fetchLinkedUserProfileEpic(graph),
    ]);
