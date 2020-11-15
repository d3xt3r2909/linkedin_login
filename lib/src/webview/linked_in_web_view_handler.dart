import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linkedin_login/src/utils/global_variables.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
class LinkedInWebViewHandler extends StatefulWidget {
  LinkedInWebViewHandler(this.configuration) : assert(configuration != null);

  final WebViewHandlerConfig configuration;

  @override
  State createState() => _LinkedInWebViewHandlerState();
}

class _LinkedInWebViewHandlerState extends State<LinkedInWebViewHandler> {
  ViewModel viewModel;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    viewModel = ViewModel.from(configuration: widget.configuration);

    // flutterWebViewPlugin.close();

    // Add a listener to on url changed
    // _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
    //   if (mounted && viewModel.isUrlMatchingToRedirection(url)) {
    //     flutterWebViewPlugin.stopLoading();
    //
    //     viewModel._fetchAuthorizationCodeResponse(url).then((value) {
    //       widget.configuration.onCallBack(value);
    //       flutterWebViewPlugin.close();
    //     });
    //   }
    // });
  }

  // @override
  // Widget build(BuildContext context) => WebviewScaffold(
  //       clearCookies: widget.configuration.destroySession,
  //       appBar: widget.configuration.appBar,
  //       url: viewModel.loginUrl,
  //       hidden: true,
  //     );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: widget.configuration.appBar,
        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: viewModel.loginUrl,
            javascriptMode: JavascriptMode.disabled,
            onWebViewCreated: (WebViewController webViewController) {
              // _controller.complete(webViewController);
              print("onWebViewCreated started loading");
            },
            navigationDelegate: (NavigationRequest request) async {
              print("::> inside navigationDelegate");
              if (viewModel.isUrlMatchingToRedirection(request.url)) {
                print("::> inside isUrlMatchingToRedirection ${request.url}");
                viewModel
                    .fetchAuthorizationCodeResponse(request.url)
                    .then((value) {
                  print("::> CALLBACK STARTED");

                  widget.configuration.onCallBack(value);
                });

                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: false,
          );
        }),
      );
}

@immutable
class ViewModel {
  const ViewModel._({
    this.configuration,
    this.clientState,
  }) : assert(configuration != null);

  factory ViewModel.from({
    @required WebViewHandlerConfig configuration,
  }) =>
      ViewModel._(
        configuration: configuration,
        clientState: Uuid().v4(),
      );

  final WebViewHandlerConfig configuration;
  final String clientState;

  String get loginUrl => '${GlobalVariables.URL_LINKED_IN_GET_AUTH_TOKEN}?'
      'response_type=code'
      '&client_id=${configuration.clientId}'
      '&state=$clientState'
      '&redirect_uri=${configuration.redirectUrl}'
      '&scope=r_liteprofile%20r_emailaddress';

  bool isUrlMatchingToRedirection(String url) =>
      configuration.isCurrentUrlMatchToRedirection(url);

  Future<AuthorizationCodeResponse> fetchAuthorizationCodeResponse(
    String url,
  ) =>
      configuration.fetchAuthorizationCodeResponse(url, clientState);
}
