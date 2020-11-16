import 'package:flutter/material.dart';

class WebViewConfigStrategy {
  WebViewConfigStrategy({
    this.configuration,
  }) : assert(configuration != null);

  Config configuration;
}


abstract class Config {
  String get clientSecret;

  List<String> get projection;

  String get redirectUrl;

  String get frontendRedirectUrl;

  String get clientId;

  PreferredSizeWidget get appBar;

  bool get destroySession;

  bool isCurrentUrlMatchToRedirection(String url);
}

abstract class WebViewConfig {
  /// [onCallBack] what to do when you receive response from LinkedIn API
  /// [redirectUrl] that you setup it on LinkedIn developer portal
  /// [clientId] value from LinkedIn developer portal
  /// [frontendRedirectUrl] if you want frontend redirection
  /// [destroySession] if you want to destroy a session
  /// [appBar] custom app bar widget
  WebViewConfig({
    @required this.redirectUrl,
    @required this.clientId,
    this.appBar,
    this.destroySession,
    this.frontendRedirectUrl,
  })  : assert(redirectUrl != null),
        assert(clientId != null);

  final String redirectUrl;
  final String frontendRedirectUrl;
  final String clientId;
  final PreferredSizeWidget appBar;
  final bool destroySession;

  bool isCurrentUrlMatchToRedirection(String url) =>
      _isRedirectionUrl(url) || _isFrontendRedirectionUrl(url);

  bool _isRedirectionUrl(String url) {
    return url.startsWith(redirectUrl);
  }

  bool _isFrontendRedirectionUrl(String url) {
    return (frontendRedirectUrl != null && url.startsWith(frontendRedirectUrl));
  }
}

class AccessCodeConfig extends WebViewConfig implements Config {
  AccessCodeConfig({
    @required String redirectUrl,
    @required String clientId,
    PreferredSizeWidget appBar,
    bool destroySession,
    String frontendRedirectUrl,
    @required this.clientSecretParam,
    @required this.projectionParam,
  }) : super(
          redirectUrl: redirectUrl,
          clientId: clientId,
          appBar: appBar,
          destroySession: destroySession,
          frontendRedirectUrl: frontendRedirectUrl,
        );

  final String clientSecretParam;
  final List<String> projectionParam;

  @override
  String get clientSecret => clientSecretParam;

  @override
  List<String> get projection => projectionParam;
}

class AuthCodeConfig extends WebViewConfig implements Config {
  AuthCodeConfig({
    @required String redirectUrl,
    @required String clientId,
    PreferredSizeWidget appBar,
    bool destroySession,
    String frontendRedirectUrl,
  }) : super(
          redirectUrl: redirectUrl,
          clientId: clientId,
          appBar: appBar,
          destroySession: destroySession,
          frontendRedirectUrl: frontendRedirectUrl,
        );

  @override
  String get clientSecret => 'N/A';

  @override
  // TODO: implement projection
  List<String> get projection => [];
}
