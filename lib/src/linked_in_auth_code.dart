import 'package:flutter/material.dart';
import 'package:linkedin_login/src/linked_in_auth_response_wrapper.dart';

import 'linked_in_auth_code_webview.dart';

/// This class is responsible to fetch all information for user after we get
/// token and code from LinkedIn
class LinkedInAuthCodeWidget extends StatefulWidget {
  final Function onGetAuthCode;
  final Function catchError;
  final String redirectUrl;
  final String clientId;
  final AppBar appBar;
  final bool destroySession;

  // just in case that frontend in your team has changed redirect url
  final String frontendRedirectUrl;

  /// Client state parameter needs to be unique range of characters - random one
  LinkedInAuthCodeWidget({
    @required this.onGetAuthCode,
    @required this.redirectUrl,
    @required this.clientId,
    this.frontendRedirectUrl,
    this.destroySession = false,
    this.catchError,
    this.appBar,
  });

  @override
  State createState() => _LinkedInAuthCodeWidgetState();
}

class _LinkedInAuthCodeWidgetState extends State<LinkedInAuthCodeWidget> {
  @override
  Widget build(BuildContext context) => LinkedInAuthCode(
        destroySession: widget.destroySession,
        frontendRedirectUrl: widget.frontendRedirectUrl,
        redirectUrl: widget.redirectUrl,
        clientId: widget.clientId,
        appBar: widget.appBar,
        onCallBack: (AuthorizationCodeResponse result) {
          if (result != null && result.code != null) {
            widget.onGetAuthCode(result);
          } else {
            // If inner class catch the error, then forward it to parent class
            if (result.error != null && result.error.description.isNotEmpty) {
              widget.catchError(result.error);
            }
          }
        },
      );
}
