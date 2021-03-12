enum WidgetType { fullProfile, authCode }

class DirectionUrlMatch {
  const DirectionUrlMatch(
    this.url,
    this.widgetType,
  );

  final String url;
  final WidgetType widgetType;

  @override
  String toString() {
    return 'DirectionUrlMatch{url: $url, widgetType: $widgetType}';
  }
}
