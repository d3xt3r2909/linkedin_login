import 'package:linkedin_login/redux/actions.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';

class DirectionUrlMatch extends LinkedInAction {
  const DirectionUrlMatch(
    this.url,
    this.configuration,
  )   : assert(url != null),
        assert(configuration != null);

  final String url;
  final Config configuration;

  @override
  String toString() {
    return 'DirectionUrlMatch{url: $url, configuration: $configuration}';
  }
}

class DirectionUrlMatchSucceededAction extends LinkedInAction {
  const DirectionUrlMatchSucceededAction(
    this.url,
    this.configuration,
  )   : assert(url != null),
        assert(configuration != null);

  final String url;
  final Config configuration;

  @override
  String toString() {
    return 'DirectionUrlMatchSucceededAction{url: $url, configuration: $configuration}';
  }
}

class DirectionUrlMatchFailedAction extends LinkedInExceptionAction {
  const DirectionUrlMatchFailedAction(Exception exception) : super(exception);
}
