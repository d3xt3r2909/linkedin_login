import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart';
import 'package:linkedin_login/src/utils/global_variables.dart';
import 'package:linkedin_login/src/utils/helper.dart';
import 'package:linkedin_login/src/utils/web_view_widget_parameters.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:linkedin_login/src/wrappers/linked_in_error_object.dart';
import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';
import 'package:uuid/uuid.dart';

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
class LinkedInAuthorization extends StatefulWidget {
  LinkedInAuthorization(this.configuration) : assert(configuration != null);

  final AuthorizationWebViewConfig configuration;

  @override
  State createState() => _LinkedInAuthorizationState();
}

class _LinkedInAuthorizationState extends State<LinkedInAuthorization> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  StreamSubscription<String> _onUrlChanged;

  ViewModel viewModel;

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    viewModel = ViewModel.from(configuration: widget.configuration);

    flutterWebViewPlugin.close();

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted && viewModel.isCurrentUrlMatchToRedirection(url)) {
        flutterWebViewPlugin.stopLoading();

        viewModel._fetchAccessToken(url).then((value) {
          widget.configuration.onCallBack(value);
          flutterWebViewPlugin.close();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => WebviewScaffold(
        clearCookies: widget.configuration.destroySession,
        appBar: widget.configuration.appBar,
        url: viewModel.loginUrl,
        hidden: true,
      );
}

@immutable
class ViewModel {
  const ViewModel._({this.configuration, this.clientState})
      : assert(configuration != null);

  factory ViewModel.from({
    @required AuthorizationWebViewConfig configuration,
  }) =>
      ViewModel._(
        configuration: configuration,
        clientState: Uuid().v4(),
      );

  final AuthorizationWebViewConfig configuration;
  final String clientState;

  String get loginUrl => '${GlobalVariables.URL_LINKED_IN_GET_AUTH_TOKEN}?'
      'response_type=code'
      '&client_id=${configuration.clientId}'
      '&state=$clientState'
      '&redirect_uri=${configuration.redirectUrl}'
      '&scope=r_liteprofile%20r_emailaddress';

  bool isCurrentUrlMatchToRedirection(String url) =>
      _isRedirectionUrl(url) || _isFrontendRedirectionUrl(url);

  bool _isRedirectionUrl(String url) {
    return url.startsWith(configuration.redirectUrl);
  }

  bool _isFrontendRedirectionUrl(String url) {
    return (configuration?.frontendRedirectUrl != null &&
        url.startsWith(configuration.frontendRedirectUrl));
  }

  Future<AuthorizationCodeResponse> _fetchAccessToken(String url) async {
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
      'redirect_uri': configuration.redirectUrl,
      'client_id': configuration.clientId,
      'client_secret': configuration.clientSecret,
    };

    final response = await post(GlobalVariables.URL_LINKED_IN_GET_ACCESS_TOKEN,
        body: body,
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
        },
        encoding: Encoding.getByName('utf-8'));

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
      ));
    }
  }
}
