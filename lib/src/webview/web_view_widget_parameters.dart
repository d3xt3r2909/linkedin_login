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
  /// [destroySession] if you want to destroy a session
  /// [appBar] custom app bar widget
  WebViewConfig({
    @required this.redirectUrl,
    @required this.clientId,
    this.appBar,
    this.destroySession,
  })  : assert(redirectUrl != null),
        assert(clientId != null);

  final String redirectUrl;
  final String clientId;
  final PreferredSizeWidget appBar;
  final bool destroySession;

  bool isRedirectionUrl(String url) {
    return url.startsWith(redirectUrl);
  }
}

class AccessCodeConfig extends WebViewConfig implements Config {
  AccessCodeConfig({
    @required String redirectUrl,
    @required String clientId,
    @required this.clientSecretParam,
    @required this.projectionParam,
    PreferredSizeWidget appBar,
    bool destroySession,
  })  : assert(clientSecretParam != null),
        assert(projectionParam != null),
        super(
          redirectUrl: redirectUrl,
          clientId: clientId,
          appBar: appBar,
          destroySession: destroySession,
        );

  final String clientSecretParam;
  final List<String> projectionParam;

  @override
  String get clientSecret => clientSecretParam;

  @override
  List<String> get projection => projectionParam;

  @override
  String get frontendRedirectUrl => null;

  @override
  bool isCurrentUrlMatchToRedirection(String url) => isRedirectionUrl(url);
}

class AuthCodeConfig extends WebViewConfig implements Config {
  AuthCodeConfig({
    @required String redirectUrl,
    @required String clientId,
    PreferredSizeWidget appBar,
    bool destroySession,
    this.frontendRedirectUrlParam,
  }) : super(
          redirectUrl: redirectUrl,
          clientId: clientId,
          appBar: appBar,
          destroySession: destroySession,
        );

  final String frontendRedirectUrlParam;

  @override
  String get clientSecret => null;

  @override
  List<String> get projection => null;

  @override
  String get frontendRedirectUrl => frontendRedirectUrlParam;

  @override
  bool isCurrentUrlMatchToRedirection(String url) =>
      isRedirectionUrl(url) || _isFrontendRedirectionUrl(url);

  bool _isFrontendRedirectionUrl(String url) {
    return (frontendRedirectUrl != null && url.startsWith(frontendRedirectUrl));
  }
}
