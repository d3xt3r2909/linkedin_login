import 'package:linkedin_login/redux/actions.dart';

class DirectionUrlMatch extends LinkedInAction {
  const DirectionUrlMatch(this.url) : assert(url != null);

  final String url;

  @override
  String toString() {
    return 'DirectionUrlMatch{url: $url}';
  }
}

class DirectionUrlMatchSucceededAction extends LinkedInAction {
  const DirectionUrlMatchSucceededAction(this.url) : assert(url != null);

  final String url;

  @override
  String toString() {
    return 'DirectionUrlMatchSucceededAction{url: $url}';
  }
}

class DirectionUrlMatchFailedAction extends LinkedInExceptionAction {
  const DirectionUrlMatchFailedAction(Exception exception) : super(exception);
}
