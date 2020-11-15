import 'package:linkedin_login/src/client/state.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  const AppState({
    @required this.linkedInUserState,
  }) : assert(linkedInUserState != null);

  factory AppState.initialState() {
    return AppState(
      linkedInUserState: LinkedInUserState.initialState(),
    );
  }

  AppState copyWith({LinkedInUserState linkedInUserState}) {
    return AppState(
      linkedInUserState: linkedInUserState ?? this.linkedInUserState,
    );
  }

  final LinkedInUserState linkedInUserState;
}
