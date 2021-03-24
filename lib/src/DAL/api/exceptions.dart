class HttpResponseException implements Exception {
  HttpResponseException({
    required this.url,
    required this.statusCode,
    this.body,
  });

  final Uri url;
  final String? body;
  final int statusCode;

  @override
  String toString() =>
      'HttpResponseException: Code $statusCode for $url with $body';
}

class AuthCodeException implements Exception {
  AuthCodeException({
    required this.authCode,
    required this.description,
  });

  final String authCode;
  final String description;

  @override
  String toString() =>
      'AuthCodeException:: for authCode: $authCode with description: $description';
}
