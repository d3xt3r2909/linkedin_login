import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:linkedin_login/src/utils/global_variables.dart';
import 'package:linkedin_login/src/utils/helper.dart';
import 'package:linkedin_login/src/utils/web_view_widget_parameters.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:uuid/uuid.dart';

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
class LinkedInAuthCode extends StatefulWidget {
  LinkedInAuthCode(this.configuration) : assert(configuration != null);

  final AuthCodeWebViewConfig configuration;

  @override
  State createState() => _LinkedInAuthCodeState();
}

/// Handle redirection with help of a FlutterWebviewPlugin
class _LinkedInAuthCodeState extends State<LinkedInAuthCode> {
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

    loginUrl = '${GlobalVariables.URL_LINKED_IN_GET_AUTH_TOKEN}?'
        'response_type=code'
        '&client_id=${widget.configuration.clientId}'
        '&state=$clientState'
        '&redirect_uri=${widget.configuration.redirectUrl}'
        '&scope=r_liteprofile%20r_emailaddress';

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted &&
          (url.startsWith(widget.configuration.redirectUrl) ||
              (widget.configuration.frontendRedirectUrl != null &&
                  url.startsWith(widget.configuration.frontendRedirectUrl)))) {
        flutterWebViewPlugin.stopLoading();

        AuthorizationCodeResponse authCode =
            getAuthorizationCode(redirectUrl: url, clientState: clientState);
        widget.configuration.onCallBack(authCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) => WebviewScaffold(
        appBar: widget.configuration.appBar,
        url: loginUrl,
        hidden: true,
        clearCookies: widget.configuration.destroySession,
      );
}
