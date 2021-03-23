enum WidgetType { fullProfile, authCode }

class DirectionUrlMatch {
  const DirectionUrlMatch({
    required this.url,
    required this.type,
  });

  final String url;
  final WidgetType type;

  @override
  String toString() {
    return 'DirectionUrlMatch{url: $url, type: $type}';
  }
}
