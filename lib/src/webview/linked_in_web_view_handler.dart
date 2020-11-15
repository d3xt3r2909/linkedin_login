import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/utils/global_variables.dart';
import 'package:linkedin_login/src/utils/session.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:redux/redux.dart';

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
class LinkedInWebViewHandler extends StatefulWidget {
  LinkedInWebViewHandler({
    @required this.config,
    this.clientSecret,
  }) : assert(config != null);

  final WebViewHandlerConfig config;
  final String clientSecret;

  @override
  State createState() => _LinkedInWebViewHandlerState();
}

class _LinkedInWebViewHandlerState extends State<LinkedInWebViewHandler> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: (store) => _ViewModel.from(
              store,
              configuration: widget.config,
              clientSecret: widget.clientSecret,
            ),
        builder: (context, viewModel) {
          return Scaffold(
            appBar: widget.config.appBar,
            body: Builder(builder: (BuildContext context) {
              return WebView(
                initialUrl: viewModel.loginUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  // _controller.complete(webViewController);
                  print("onWebViewCreated started loading");
                },
                navigationDelegate: (NavigationRequest request) async {
                  print("::> inside navigationDelegate");
                  if (viewModel.isUrlMatchingToRedirection(request.url)) {
                    viewModel.onRedirectionUrl(request.url);
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
        });
  }
}

@immutable
class _ViewModel {
  const _ViewModel._({
    @required this.onDispatch,
    @required this.configuration,
    @required this.clientSecret,
  })  : assert(onDispatch != null),
        assert(configuration != null);

  factory _ViewModel.from(
    Store<AppState> store, {
    @required WebViewHandlerConfig configuration,
    @required String clientSecret,
  }) =>
      _ViewModel._(
        onDispatch: store.dispatch,
        configuration: configuration,
        clientSecret: clientSecret,
      );

  final WebViewHandlerConfig configuration;
  final Function(dynamic) onDispatch;
  final String clientSecret;

  void onRedirectionUrl(String url) => onDispatch(
        DirectionUrlMatch(
          url,
          configuration.clientId,
          clientSecret: clientSecret,
        ),
      );

  String get loginUrl => '${GlobalVariables.URL_LINKED_IN_GET_AUTH_TOKEN}?'
      'response_type=code'
      '&client_id=${configuration.clientId}'
      '&state=${Session.clientState}'
      '&redirect_uri=${configuration.redirectUrl}'
      '&scope=r_liteprofile%20r_emailaddress';

  bool isUrlMatchingToRedirection(String url) =>
      configuration.isCurrentUrlMatchToRedirection(url);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          configuration == other.configuration;

  @override
  int get hashCode => configuration.hashCode;
}
