import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart';
import 'package:linkedin_login/src/linked_in_auth_response_wrapper.dart';
import 'package:uuid/uuid.dart';

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
class LinkedInAuthorization extends StatefulWidget {
  final Function onCallBack;
  final String redirectUrl;
  final String clientId, clientSecret;

  LinkedInAuthorization({
    @required this.onCallBack,
    @required this.redirectUrl,
    @required this.clientId,
    @required this.clientSecret,
  });

  @override
  State createState() => _LinkedInAuthorizationState();
}

class _LinkedInAuthorizationState extends State<LinkedInAuthorization> {
  final urlLinkedInAccessToken =
      'https://www.linkedin.com/oauth/v2/accessToken';
  final urlLinkedInAuthorization =
      'https://www.linkedin.com/oauth/v2/authorization';
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  StreamSubscription<String> _onUrlChanged;
  AuthorizationCodeResponse authorizationCodeResponse;

  String clientState, loginUrl;

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    clientState = Uuid().v4();

    flutterWebViewPlugin.close();

    loginUrl = '$urlLinkedInAuthorization?'
        'response_type=code'
        '&client_id=${widget.clientId}'
        '&state=$clientState'
        '&redirect_uri=${widget.redirectUrl}'
        '&scope=r_liteprofile%20r_emailaddress';

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted && url.startsWith(widget.redirectUrl)) {
        flutterWebViewPlugin.stopLoading();
        _getAuthorizationCode(url: url).then(
          (AuthorizationCodeResponse result) {
            widget.onCallBack(result);
          },
        );
      }
    });
  }

  /// Method that will retrieve authorization code
  /// After auth code is received you can call API service to get access token
  /// from linkedIn
  Future<AuthorizationCodeResponse> _getAuthorizationCode({String url}) async {
    AuthorizationCodeResponse response;

    // logic for parsing URL from your redirect url so that we can get access
    // code

    final List<String> parseUrl = url.split('?');

    if (parseUrl.isNotEmpty) {
      final List<String> queryPart = parseUrl.last.split('&');

      if (queryPart.isNotEmpty && queryPart.first.startsWith('code')) {
        final List<String> codePart = queryPart.first.split('=');
        final List<String> statePart = queryPart.last.split('=');

        if (statePart[1] == clientState) {
          response = AuthorizationCodeResponse(
            code: codePart[1],
            state: statePart[1],
          );
        } else {
          AuthorizationCodeResponse(
            error: LinkedInErrorObject(
              statusCode: HttpStatus.unauthorized,
              description: 'State code is not valid: ${statePart[1]}',
            ),
            state: statePart[1],
          );
        }
      } else if (queryPart.isNotEmpty && queryPart.first.startsWith('error')) {
        response = AuthorizationCodeResponse(
          error: LinkedInErrorObject(
            statusCode: HttpStatus.unauthorized,
            description: queryPart[1].split('=')[1].replaceAll('+', ' '),
          ),
          state: queryPart[2].split('=')[1],
        );
      }
    }

    // get access token based on code
    if (response.code != null && response.code.isNotEmpty) {
      final LinkedInTokenObject tokenObject = await _getAccessToken(response);

      if (tokenObject.error == null || tokenObject.error.description.isEmpty) {
        response.accessToken = tokenObject;
      } else {
        response.error = LinkedInErrorObject(
          statusCode: HttpStatus.unauthorized,
          description: 'Failed to get user token',
        );
        response.accessToken = null;
        response.code = null;
        response.state = null;
      }
    }

    flutterWebViewPlugin.close();

    return response;
  }

  /// Method for getting token object for current user
  /// This method will return you token & expiration time for that token
  Future<LinkedInTokenObject> _getAccessToken(
      AuthorizationCodeResponse codeDetails) async {
    final Map<String, dynamic> body = {
      'grant_type': 'authorization_code',
      'code': codeDetails.code,
      'redirect_uri': widget.redirectUrl,
      'client_id': widget.clientId,
      'client_secret': widget.clientSecret,
    };

    final response = await post(urlLinkedInAccessToken,
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

  @override
  Widget build(BuildContext context) => WebviewScaffold(
        url: loginUrl,
      );
}
