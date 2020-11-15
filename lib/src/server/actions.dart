import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/redux/actions.dart';

class FetchAuthCode extends LinkedInAction {
  const FetchAuthCode();

  @override
  String toString() {
    return 'FetchAuthCode{}';
  }
}

class FetchAuthCodeSucceededAction extends LinkedInAction {
  const FetchAuthCodeSucceededAction(this.authCode) : assert(authCode != null);

  final AuthorizationCodeResponse authCode;

  @override
  String toString() {
    return 'FetchAuthCodeSucceededAction{token: $authCode}';
  }
}

class FetchAuthCodeFailedAction extends LinkedInExceptionAction {
  const FetchAuthCodeFailedAction(Exception exception) : super(exception);
}
