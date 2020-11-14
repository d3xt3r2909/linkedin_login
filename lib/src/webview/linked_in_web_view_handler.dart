import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:linkedin_login/src/utils/global_variables.dart';
import 'package:linkedin_login/src/utils/web_view_widget_parameters.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:uuid/uuid.dart';

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
class LinkedInWebViewHandler extends StatefulWidget {
  LinkedInWebViewHandler(this.configuration) : assert(configuration != null);

  final WebViewWidgetConfig configuration;

  @override
  State createState() => _LinkedInWebViewHandlerState();
}

class _LinkedInWebViewHandlerState extends State<LinkedInWebViewHandler> {
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

        viewModel._fetchAuthorizationCodeResponse(url).then((value) {
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
  const ViewModel._({
    this.configuration,
    this.clientState,
  }) : assert(configuration != null);

  factory ViewModel.from({
    @required WebViewWidgetConfig configuration,
  }) =>
      ViewModel._(
        configuration: configuration,
        clientState: Uuid().v4(),
      );

  final WebViewWidgetConfig configuration;
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

  Future<AuthorizationCodeResponse> _fetchAuthorizationCodeResponse(
    String url,
  ) =>
      configuration.fetchAuthorizationCodeResponse(
        url,
        clientState,
      );
}
