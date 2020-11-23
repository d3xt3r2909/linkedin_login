import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/session.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:redux/redux.dart';

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
class LinkedInWebViewHandler extends StatefulWidget {
  LinkedInWebViewHandler({
    this.appBar,
    this.destroySession,
    this.onWebViewCreated, // this is just for testing purpose
  }) : assert(destroySession != null);

  final bool destroySession;
  final PreferredSizeWidget appBar;
  final Function(WebViewController) onWebViewCreated;

  @override
  State createState() => _LinkedInWebViewHandlerState();
}

class _LinkedInWebViewHandlerState extends State<LinkedInWebViewHandler> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) {

        return _ViewModel.from(
          store,
        );
      }
      builder: (context, viewModel) {
        return Scaffold(
          appBar: widget.appBar,
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
  }) : assert(onDispatch != null);

  factory _ViewModel.from(Store<AppState> store) => _ViewModel._(
        onDispatch: store.dispatch,
      );

  final Function(dynamic) onDispatch;

  void onRedirectionUrl(String url) => onDispatch(DirectionUrlMatch(url));

  String get loginUrl => '${UrlAccessPoint.URL_LINKED_IN_GET_AUTH_TOKEN}?'
      'response_type=code'
      '&client_id=${configuration.clientId}'
      '&state=${Session.clientState}'
      '&redirect_uri=${configuration.redirectUrl}'
      '&scope=r_liteprofile%20r_emailaddress';

  bool isUrlMatchingToRedirection(String url) =>
      configuration.isCurrentUrlMatchToRedirection(url);
}
