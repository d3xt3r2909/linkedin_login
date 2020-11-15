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
    this.configuration, {
    this.clientSecret,
  }) : assert(configuration != null);

  final WebViewHandlerConfig configuration;
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
              configuration: widget.configuration,
              clientSecret: widget.clientSecret,
            ),
        builder: (context, viewModel) {
          return Scaffold(
            appBar: widget.configuration.appBar,
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
                    print(
                        "::> inside isUrlMatchingToRedirection ${request.url}");
                    // viewModel
                    //     .fetchAuthorizationCodeResponse(request.url)
                    //     .then((value) {
                    //   print("::> CALLBACK STARTED");
                    //
                    //   widget.configuration.onCallBack(value);
                    // });

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
    @required this.clientState,
    @required this.clientSecret,
  })  : assert(onDispatch != null),
        assert(configuration != null),
        assert(clientState != null);

  factory _ViewModel.from(
    Store<AppState> store, {
    @required WebViewHandlerConfig configuration,
    @required String clientSecret,
  }) =>
      _ViewModel._(
        onDispatch: store.dispatch,
        configuration: configuration,
        clientState: Session.clientState,
        clientSecret: clientSecret,
      );

  final WebViewHandlerConfig configuration;
  final String clientState;
  final Function(dynamic) onDispatch;
  final String clientSecret;

  void onRedirectionUrl(String url) => onDispatch(
        DirectionUrlMatch(
          url,
          clientState,
          configuration.clientId,
          clientSecret: clientSecret,
        ),
      );

  String get loginUrl => '${GlobalVariables.URL_LINKED_IN_GET_AUTH_TOKEN}?'
      'response_type=code'
      '&client_id=${configuration.clientId}'
      '&state=$clientState'
      '&redirect_uri=${configuration.redirectUrl}'
      '&scope=r_liteprofile%20r_emailaddress';

  bool isUrlMatchingToRedirection(String url) =>
      configuration.isCurrentUrlMatchToRedirection(url);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          configuration == other.configuration &&
          clientState == other.clientState;

  @override
  int get hashCode => configuration.hashCode ^ clientState.hashCode;
}
