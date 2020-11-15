import 'package:linkedin_login/src/server/actions.dart';
import 'package:linkedin_login/src/server/state.dart';

UserAuthCodeState linkedInServerReducer(
  UserAuthCodeState state,
  dynamic action,
) {
  if (action is FetchAuthCodeSucceededAction) {
    return state.copyWith(
      userAuthCode: action.authCode,
    );
  }

  return state;
}
