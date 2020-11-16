import 'dart:async';

import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/repository.dart';
import 'package:linkedin_login/src/client/actions.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> _fetchAccessTokenEpic() => (
      Stream<dynamic> actions,
      EpicStore<AppState> store,
    ) {
      return actions
          .whereType<DirectionUrlMatchSucceededAction>()
          .switchMap(_fetchAccessTokenUser);
    };

Stream<dynamic> _fetchAccessTokenUser(
  DirectionUrlMatchSucceededAction action,
) async* {
  try {
    final authorizationCodeResponse = await LinkedInRepository(
      redirectionUrl: action.url,
      clientId: action.configuration.clientId,
    ).fetchWithAccessTokenCode(
      clientSecret: action.configuration.clientSecret,
    );

    yield FetchAccessCodeSucceededAction(authorizationCodeResponse.accessToken);
  } on Exception catch (e) {
    yield FetchAccessCodeFailedAction(e);
  }
}

Epic<AppState> _fetchLinkedUserProfileEpic() => (
      Stream<dynamic> actions,
      EpicStore<AppState> store,
    ) {
      return actions
          .whereType<FetchAccessCodeSucceededAction>()
          .switchMap(_fetchLinkedInProfile);
    };

Stream<dynamic> _fetchLinkedInProfile(
  FetchAccessCodeSucceededAction action,
) async* {
  try {
    final user = await LinkedInUserRepositoryImpl(action.token)
        .fetchFullLinkedInUserProfile();

    yield FetchLinkedInUserSucceededAction(user);
  } on Exception catch (e) {
    yield FetchLinkedInUserFailedAction(e);
  }
}

Epic<AppState> clientEpics() => combineEpics<AppState>([
      _fetchAccessTokenEpic(),
      _fetchLinkedUserProfileEpic(),
    ]);
