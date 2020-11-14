import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:linkedin_login/src/utils/global_variables.dart';
import 'package:linkedin_login/src/utils/helper.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:linkedin_login/src/wrappers/linked_in_error_object.dart';
import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';

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

  Future<AuthorizationCodeResponse> fetchAuthorizationCodeResponse(
    String url,
    String clientState,
  );

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

  @override
  Future<AuthorizationCodeResponse> fetchAuthorizationCodeResponse(
    String url,
    String clientState,
  ) async {
    AuthorizationCodeResponse authCode =
        getAuthorizationCode(redirectUrl: url, clientState: clientState);
    final accessToken = await _getAccessToken(authorizationCode: authCode);

    return accessToken;
  }

  // @todo move to DAL
  /// Method that will retrieve authorization code
  /// After auth code is received you can call API service to get access token
  /// from linkedIn
  /// If error happens it will be saved into [error] property of result object
  Future<AuthorizationCodeResponse> _getAccessToken({
    AuthorizationCodeResponse authorizationCode,
  }) async {
    // get access token based on code
    if (authorizationCode.code != null && authorizationCode.code.isNotEmpty) {
      final LinkedInTokenObject tokenObject =
          await _getUserProfile(authorizationCode);

      if (tokenObject.isSuccess) {
        authorizationCode.accessToken = tokenObject;
      } else {
        authorizationCode.errorObject = tokenObject.error;
      }
    }

    return authorizationCode;
  }

  // @todo move to DAL
  /// Method for getting token object for current user
  /// This method will return you token & expiration time for that token
  Future<LinkedInTokenObject> _getUserProfile(
    AuthorizationCodeResponse codeDetails,
  ) async {
    final Map<String, dynamic> body = {
      'grant_type': 'authorization_code',
      'code': codeDetails.code,
      'redirect_uri': redirectUrl,
      'client_id': clientId,
      'client_secret': clientSecret,
    };

    final response = await post(
      GlobalVariables.URL_LINKED_IN_GET_ACCESS_TOKEN,
      body: body,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
      },
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == HttpStatus.ok) {
      return LinkedInTokenObject(
        accessToken: json.decode(response.body)['access_token'].toString(),
        expiresIn: json.decode(response.body)['expires_in'],
      );
    } else {
      return LinkedInTokenObject(
        error: LinkedInErrorObject(
          description: 'Failed to get token',
          statusCode: response.statusCode,
        ),
      );
    }
  }
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

  @override
  Future<AuthorizationCodeResponse> fetchAuthorizationCodeResponse(
    String url,
    String clientState,
  ) {
    final authCode = getAuthorizationCode(
      redirectUrl: url,
      clientState: clientState,
    );
    return Future.value(authCode);
  }
}
