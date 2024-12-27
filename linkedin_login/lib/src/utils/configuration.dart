import 'package:linkedin_login/src/utils/scopes.dart';

abstract class Config {
  String? get clientSecret;

  String? get redirectUrl;

  String? get frontendRedirectUrl;

  String? get clientId;

  String get state;

  String get initialUrl;

  String parseScopesToQueryParam(final List<Scope> scopes) =>
      scopes.map((final e) => e.permission).join('%20');

  bool isCurrentUrlMatchToRedirection(final String url);
}

class AccessCodeConfiguration extends Config {
  AccessCodeConfiguration({
    required this.redirectUrlParam,
    required this.clientIdParam,
    required this.clientSecretParam,
    required this.urlState,
    required this.scopeParam,
  });

  final String? clientSecretParam;
  final String? redirectUrlParam;
  final String? clientIdParam;
  final String urlState;
  final List<Scope> scopeParam;

  @override
  String? get clientId => clientIdParam;

  @override
  String? get clientSecret => clientSecretParam;

  @override
  String? get frontendRedirectUrl => null;

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
      '&scope=${parseScopesToQueryParam(scopeParam)}';

  @override
  bool isCurrentUrlMatchToRedirection(final String url) =>
      _isRedirectionUrl(url);

  bool _isRedirectionUrl(final String url) {
    return url.startsWith(redirectUrl!);
  }

  @override
  String toString() {
    return 'AccessCodeConfiguration{clientSecretParam: '
        '${clientSecretParam!.isNotEmpty ? 'XXX' : 'INVALID'}, '
        ' redirectUrlParam: $redirectUrlParam,'
        ' clientIdParam: $clientIdParam, urlState: $urlState}, '
        'scope:${parseScopesToQueryParam(scopeParam)}';
  }
}

class AuthCodeConfiguration extends Config {
  AuthCodeConfiguration({
    required this.redirectUrlParam,
    required this.clientIdParam,
    required this.urlState,
    required this.scopeParam,
    this.frontendRedirectUrlParam,
  });

  final String? redirectUrlParam;
  final String? clientIdParam;
  final String? frontendRedirectUrlParam;
  final String urlState;
  final List<Scope> scopeParam;

  @override
  String? get clientId => clientIdParam;

  @override
  String? get clientSecret => null;

  @override
  String? get frontendRedirectUrl => frontendRedirectUrlParam;

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
      '&scope=${parseScopesToQueryParam(scopeParam)}';

  @override
  bool isCurrentUrlMatchToRedirection(final String url) =>
      _isRedirectionUrl(url) || _isFrontendRedirectionUrl(url);

  bool _isRedirectionUrl(final String url) {
    return url.startsWith(redirectUrl!);
  }

  bool _isFrontendRedirectionUrl(final String url) {
    return frontendRedirectUrl != null && url.startsWith(frontendRedirectUrl!);
  }
}
