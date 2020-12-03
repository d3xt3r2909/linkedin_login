import 'package:linkedin_login/redux/actions.dart';

enum WidgetType { full_profile, auth_code }

class DirectionUrlMatch extends LinkedInAction {
  const DirectionUrlMatch(
    this.url,
    this.widgetType,
  )   : assert(url != null),
        assert(widgetType != null);

  final String url;
  final WidgetType widgetType;

  @override
  String toString() {
    return 'DirectionUrlMatch{url: $url, widgetType: $widgetType}';
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
