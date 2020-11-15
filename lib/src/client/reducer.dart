import 'package:linkedin_login/src/client/actions.dart';
import 'package:linkedin_login/src/client/state.dart';

LinkedInUserState linkedInClientReducer(
  LinkedInUserState state,
  dynamic action,
) {
  if (action is FetchLinkedInUserSucceededAction) {
    return state.copyWith(
      linkedInUser: action.linkedInUser,
    );
  }

  return state;
}
