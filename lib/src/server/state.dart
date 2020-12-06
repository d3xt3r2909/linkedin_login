import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:meta/meta.dart';

@immutable
class UserAuthCodeState {
  const UserAuthCodeState({
    @required this.userAuthCode,
  }) : assert(userAuthCode != null);

  const UserAuthCodeState.initialState() : userAuthCode = null;

  final AuthorizationCodeResponse userAuthCode;

  UserAuthCodeState copyWith({
    AuthorizationCodeResponse userAuthCode,
  }) =>
      UserAuthCodeState(userAuthCode: userAuthCode ?? this.userAuthCode);
}
