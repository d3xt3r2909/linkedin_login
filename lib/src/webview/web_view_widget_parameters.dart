import 'package:flutter/material.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
abstract class WebViewHandlerConfig {
  /// [onCallBack] what to do when you receive response from LinkedIn API
  /// [redirectUrl] that you setup it on LinkedIn developer portal
  /// [clientId] value from LinkedIn developer portal
  /// [frontendRedirectUrl] if you want frontend redirection
  /// [destroySession] if you want to destroy a session
  /// [appBar] custom app bar widget
  WebViewHandlerConfig({
    @required this.onCallBack,
    @required this.redirectUrl,
    @required this.clientId,
    this.appBar,
    this.destroySession,
    this.frontendRedirectUrl,
  })  : assert(onCallBack != null),
        assert(redirectUrl != null),
        assert(clientId != null);

  final Function(AuthorizationCodeResponse) onCallBack;
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

class AuthorizationWebViewConfig extends WebViewHandlerConfig {
  AuthorizationWebViewConfig({
    @required this.clientSecret,
    @required Function(AuthorizationCodeResponse) onCallBack,
    @required String redirectUrl,
    @required String clientId,
    PreferredSizeWidget appBar,
    bool destroySession,
    String frontendRedirectUrl,
  })  : assert(clientSecret != null),
        super(
          onCallBack: onCallBack,
          redirectUrl: redirectUrl,
          clientId: clientId,
          appBar: appBar,
          destroySession: destroySession,
          frontendRedirectUrl: frontendRedirectUrl,
        );

  final String clientSecret;
}

class AuthCodeWebViewConfig extends WebViewHandlerConfig {
  AuthCodeWebViewConfig({
    @required Function(AuthorizationCodeResponse) onCallBack,
    @required String redirectUrl,
    @required String clientId,
    PreferredSizeWidget appBar,
    bool destroySession,
    String frontendRedirectUrl,
  }) : super(
          onCallBack: onCallBack,
          redirectUrl: redirectUrl,
          clientId: clientId,
          appBar: appBar,
          destroySession: destroySession,
          frontendRedirectUrl: frontendRedirectUrl,
        );
}
