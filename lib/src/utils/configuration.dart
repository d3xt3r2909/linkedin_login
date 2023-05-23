import 'package:linkedin_login/src/utils/scopes.dart';

abstract class Config {
  String? get clientSecret;

  List<String>? get projection;

  String? get redirectUrl;

  String? get frontendRedirectUrl;

  String? get clientId;

  String get state;

  Uri get initialUri;

  String get scopeQueryParam;

  bool isCurrentUrlMatchToRedirection(final String url);
}

class AccessCodeConfiguration implements Config {
  AccessCodeConfiguration({
    required this.redirectUrlParam,
    required this.clientIdParam,
    required this.clientSecretParam,
    required this.projectionParam,
    required this.urlState,
    required this.scopes,
  });

  final String? clientSecretParam;
  final List<String> projectionParam;
  final String? redirectUrlParam;
  final String? clientIdParam;
  final String urlState;
  final List<Scopes> scopes;

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
  Uri get initialUri {
    return Uri.https(
      'www.linkedin.com',
      '/oauth/v2/authorization',
      {
        'response_type': 'code',
        'client_id': clientId,
        'state': state,
        'redirect_uri': redirectUrl,
        'scope': scopeQueryParam,
      },
    );
  }

  @override
  String get scopeQueryParam => scopes.map((final e) => e.value).join(' ');

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
        'projectionParam: $projectionParam,'
        ' redirectUrlParam: $redirectUrlParam,'
        ' scope: $scopeQueryParam,'
        ' clientIdParam: $clientIdParam, urlState: $urlState}';
  }
}

class AuthCodeConfiguration implements Config {
  AuthCodeConfiguration({
    required this.redirectUrlParam,
    required this.clientIdParam,
    required this.urlState,
    required this.scopes,
    this.frontendRedirectUrlParam,
  });

  final String? redirectUrlParam;
  final String? clientIdParam;
  final String? frontendRedirectUrlParam;
  final String urlState;
  final List<Scopes> scopes;

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
  Uri get initialUri => Uri.https(
        'www.linkedin.com',
        '/oauth/v2/authorization',
        {
          'response_type': 'code',
          'client_id': clientId,
          'state': state,
          'redirect_uri': redirectUrl,
          'scope': scopeQueryParam,
        },
      );

  @override
  String get scopeQueryParam => scopes.map((final e) => e.value).join(' ');

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
