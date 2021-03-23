abstract class Config {
  String? get clientSecret;

  List<String>? get projection;

  String? get redirectUrl;

  String? get frontendRedirectUrl;

  String? get clientId;

  String get state;

  String get initialUrl;

  bool isCurrentUrlMatchToRedirection(String url);
}

class AccessCodeConfiguration implements Config {
  AccessCodeConfiguration({
    required this.redirectUrlParam,
    required this.clientIdParam,
    required this.clientSecretParam,
    required this.projectionParam,
    required this.urlState,
  });

  final String? clientSecretParam;
  final List<String> projectionParam;
  final String? redirectUrlParam;
  final String? clientIdParam;
  final String urlState;

  @override
  String? get clientId => clientIdParam;

  @override
  String? get clientSecret => clientSecretParam;

  @override
  String? get frontendRedirectUrl => null;

  @override
  List<String> get projection => projectionParam;

  @override
  String? get redirectUrl => redirectUrlParam;

  @override
  String get state => urlState;

  @override
  String get initialUrl => 'https://www.linkedin.com/oauth/v2/authorization?'
      'response_type=code'
      '&client_id=$clientId'
      '&state=$urlState'
      '&redirect_uri=$redirectUrl'
      '&scope=r_liteprofile%20r_emailaddress';

  @override
  bool isCurrentUrlMatchToRedirection(String url) => _isRedirectionUrl(url);

  bool _isRedirectionUrl(String url) {
    return url.startsWith(redirectUrl!);
  }

  @override
  String toString() {
    return 'AccessCodeConfiguration{clientSecretParam: ${clientSecretParam!.isNotEmpty ? 'XXX' : 'INVALID'}, projectionParam: $projectionParam, redirectUrlParam: $redirectUrlParam, clientIdParam: $clientIdParam, urlState: $urlState}';
  }
}

class AuthCodeConfiguration implements Config {
  AuthCodeConfiguration({
    required this.redirectUrlParam,
    required this.clientIdParam,
    required this.urlState,
    this.frontendRedirectUrlParam,
  });

  final String? redirectUrlParam;
  final String? clientIdParam;
  final String? frontendRedirectUrlParam;
  final String urlState;

  @override
  String? get clientId => clientIdParam;

  @override
  String? get clientSecret => null;

  @override
  String? get frontendRedirectUrl => frontendRedirectUrlParam;

  @override
  List<String>? get projection => null;

  @override
  String? get redirectUrl => redirectUrlParam;

  @override
  String get state => urlState;

  @override
  String get initialUrl => 'https://www.linkedin.com/oauth/v2/authorization?'
      'response_type=code'
      '&client_id=$clientId'
      '&state=$state'
      '&redirect_uri=$redirectUrl'
      '&scope=r_liteprofile%20r_emailaddress';

  @override
  bool isCurrentUrlMatchToRedirection(String url) =>
      _isRedirectionUrl(url) || _isFrontendRedirectionUrl(url);

  bool _isRedirectionUrl(String url) {
    return url.startsWith(redirectUrl!);
  }

  bool _isFrontendRedirectionUrl(String url) {
    return frontendRedirectUrl != null && url.startsWith(frontendRedirectUrl!);
  }
}
