import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:linkedin_login/helper/global_variables.dart';
import 'package:linkedin_login/helper/helper_methods.dart';
import 'package:linkedin_login/src/linked_in_auth_response_wrapper.dart';
import 'package:uuid/uuid.dart';

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
class LinkedInAuthCode extends StatefulWidget {
  final Function onCallBack;
  final String redirectUrl;
  final String clientId;
  final AppBar appBar;

  // just in case that frontend in your team has changed redirect url
  final String frontendRedirectUrl;

  LinkedInAuthCode({
    @required this.onCallBack,
    @required this.redirectUrl,
    @required this.clientId,
    this.frontendRedirectUrl,
    this.appBar,
  });

  @override
  State createState() => _LinkedInAuthCodeState();
}

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
        '&client_id=${widget.clientId}'
        '&state=$clientState'
        '&redirect_uri=${widget.redirectUrl}'
        '&scope=r_liteprofile%20r_emailaddress';

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted &&
          (url.startsWith(widget.redirectUrl) ||
              (widget.frontendRedirectUrl != null &&
                  url.startsWith(widget.frontendRedirectUrl)))) {
        flutterWebViewPlugin.stopLoading();

        AuthorizationCodeResponse authCode =
            getAuthorizationCode(redirectUrl: url, clientState: clientState);
        widget.onCallBack(authCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) => WebviewScaffold(
        appBar: widget.appBar,
        url: loginUrl,
        hidden: true,
      );
}
