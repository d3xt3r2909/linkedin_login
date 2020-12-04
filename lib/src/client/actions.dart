import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/redux/actions.dart';

class FetchAccessCode extends LinkedInAction {
  const FetchAccessCode(this.url) : assert(url != null);

  final String url;

  @override
  String toString() {
    return 'FetchAccessCode{url: $url}';
  }
}

class FetchAccessCodeSucceededAction extends LinkedInAction {
  const FetchAccessCodeSucceededAction(this.token) : assert(token != null);

  final LinkedInTokenObject token;

  @override
  String toString() {
    return 'FetchAccessCodeSucceededAction{token: $token}';
  }
}

class FetchAccessCodeFailedAction extends LinkedInExceptionAction {
  const FetchAccessCodeFailedAction(Exception exception) : super(exception);
}

class FetchLinkedInUser extends LinkedInAction {
  const FetchLinkedInUser(this.token) : assert(token != null);

  final LinkedInTokenObject token;

  @override
  String toString() {
    return 'FetchLinkedInUser{token: $token}';
  }
}

class FetchLinkedInUserSucceededAction extends LinkedInAction {
  const FetchLinkedInUserSucceededAction(this.linkedInUser)
      : assert(linkedInUser != null);

  final LinkedInUserModel linkedInUser;

  @override
  String toString() {
    return 'FetchLinkedInUserSucceededAction{linkedInUser: $linkedInUser}';
  }
}

class FetchLinkedInUserFailedAction extends LinkedInExceptionAction {
  const FetchLinkedInUserFailedAction(Exception exception) : super(exception);
}
