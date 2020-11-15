import 'package:linkedin_login/src/client/state.dart';
import 'package:linkedin_login/src/server/state.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  const AppState({
    @required this.linkedInUserState,
    @required this.userAuthCodeState,
  })  : assert(linkedInUserState != null),
        assert(userAuthCodeState != null);

  factory AppState.initialState() {
    return AppState(
      linkedInUserState: LinkedInUserState.initialState(),
      userAuthCodeState: UserAuthCodeState.initialState(),
    );
  }

  AppState copyWith({
    LinkedInUserState linkedInUserState,
    UserAuthCodeState userAuthCodeState,
  }) {
    return AppState(
      linkedInUserState: linkedInUserState ?? this.linkedInUserState,
      userAuthCodeState: userAuthCodeState ?? this.userAuthCodeState,
    );
  }

  final LinkedInUserState linkedInUserState;
  final UserAuthCodeState userAuthCodeState;
}
