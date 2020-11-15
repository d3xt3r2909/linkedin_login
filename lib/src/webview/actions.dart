import 'package:linkedin_login/redux/actions.dart';

class DirectionUrlMatch extends LinkedInAction {
  const DirectionUrlMatch(
    this.url,
    this.clientId, {
    this.clientSecret,
  })  : assert(url != null),
        assert(clientId != null);

  final String url;
  final String clientId;
  final String clientSecret;

  @override
  String toString() {
    return 'DirectionUrlMatch{url: $url, clientId: $clientId, clientSecret: $clientSecret}';
  }
}

class DirectionUrlMatchSucceededAction extends LinkedInAction {
  const DirectionUrlMatchSucceededAction(
    this.url,
    this.clientId, {
    this.clientSecret,
  })  : assert(url != null),
        assert(clientId != null);

  final String url;
  final String clientId;
  final String clientSecret;

  @override
  String toString() {
    return 'DirectionUrlMatchSucceededAction{url: $url, clientId: $clientId, clientSecret: $clientSecret}';
  }
}

class DirectionUrlMatchFailedAction extends LinkedInExceptionAction {
  const DirectionUrlMatchFailedAction(Exception exception) : super(exception);
}
