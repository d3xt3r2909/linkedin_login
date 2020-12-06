import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:redux/redux.dart';

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
@immutable
class LinkedInWebViewHandler extends StatefulWidget {
  const LinkedInWebViewHandler({
    this.appBar,
    this.destroySession = false,
    this.onCookieClear,
    this.onWebViewCreated, // this is just for testing purpose
  }) : assert(destroySession != null);

  final bool destroySession;
  final PreferredSizeWidget appBar;
  final Function(WebViewController) onWebViewCreated;
  final Function(bool) onCookieClear;

  @override
  State createState() => _LinkedInWebViewHandlerState();
}

class _LinkedInWebViewHandlerState extends State<LinkedInWebViewHandler> {
  WebViewController webViewController;
  final CookieManager cookieManager = CookieManager();

  @override
  void initState() {
    super.initState();

    if (widget.destroySession) {
      log('LinkedInAuth-steps: cache clearing... ');
      cookieManager.clearCookies().then((value) {
        widget?.onCookieClear?.call(true);
        log('LinkedInAuth-steps: cache clearing... DONE');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.from(store, context),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: widget.appBar,
          body: Builder(
            builder: (BuildContext context) {
              return WebView(
                initialUrl: viewModel.initialUrl(context),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) async {
                  log('LinkedInAuth-steps: onWebViewCreated ... ');

                  if (widget.onWebViewCreated != null) {
                    widget.onWebViewCreated(webViewController);
                  }

                  log('LinkedInAuth-steps: onWebViewCreated ... DONE');
                },
                navigationDelegate: (NavigationRequest request) async {
                  log('LinkedInAuth-steps: navigationDelegate ... ');
                  final isMatch = viewModel.isUrlMatchingToRedirection(
                    context,
                    request.url,
                  );
                  log(
                    'LinkedInAuth-steps: navigationDelegate '
                    '[currentUrL: ${request.url}, isCurrentMatch: $isMatch]',
                  );

                  if (isMatch) {
                    viewModel.onRedirectionUrl(request.url);
                    log('Navigation delegate prevent... done');
                    return NavigationDecision.prevent;
                  }

                  return NavigationDecision.navigate;
                },
                gestureNavigationEnabled: false,
              );
            },
          ),
        );
      },
    );
  }
}

@immutable
class _ViewModel {
  const _ViewModel._({
    @required this.onDispatch,
    @required this.graph,
  }) : assert(onDispatch != null);

  factory _ViewModel.from(Store<AppState> store, BuildContext context) =>
      _ViewModel._(
        onDispatch: store.dispatch,
        graph: InjectorWidget.of(context),
      );

  final Function(dynamic) onDispatch;
  final Graph graph;

  void onRedirectionUrl(String url) {
    final type = graph.linkedInConfiguration is AccessCodeConfiguration
        ? WidgetType.fullProfile
        : WidgetType.authCode;
    onDispatch(DirectionUrlMatch(url, type));
  }

  String initialUrl(BuildContext context) {
    return graph.linkedInConfiguration.initialUrl;
  }

  bool isUrlMatchingToRedirection(BuildContext context, String url) {
    return graph.linkedInConfiguration.isCurrentUrlMatchToRedirection(url);
  }
}
