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
  LinkedInWebViewHandler(
    this.config, {
    this.onWebViewCreated, // this is just for testing purpose
  }) : assert(config != null);

  final WebViewConfigStrategy config;
  final Function(WebViewController) onWebViewCreated;

  @override
  State createState() => _LinkedInWebViewHandlerState();
}

class _LinkedInWebViewHandlerState extends State<LinkedInWebViewHandler> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.from(
        store,
        configuration: widget.config.configuration,
      ),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: widget.config.configuration.appBar,
          body: Builder(builder: (BuildContext context) {
            return WebView(
              initialUrl: viewModel.loginUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                if (widget.onWebViewCreated != null) {
                  widget.onWebViewCreated(webViewController);
                }
              },
              navigationDelegate: (NavigationRequest request) async {
                if (viewModel.isUrlMatchingToRedirection(request.url)) {
                  viewModel.onRedirectionUrl(request.url);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('::> Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('::> Page finished loading: $url');
              },
              gestureNavigationEnabled: false,
            );
          }),
        );
      },
    );
  }
}

@immutable
class _ViewModel {
  const _ViewModel._({
    @required this.onDispatch,
    @required this.configuration,
  })  : assert(onDispatch != null),
        assert(configuration != null);

  factory _ViewModel.from(
    Store<AppState> store, {
    @required Config configuration,
  }) =>
      _ViewModel._(
        onDispatch: store.dispatch,
        configuration: configuration,
      );

  // @todo expose what we need from config
  final Config configuration;
  final Function(dynamic) onDispatch;

  void onRedirectionUrl(String url) =>
      onDispatch(DirectionUrlMatch(url, configuration));

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
