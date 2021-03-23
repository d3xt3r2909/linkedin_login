import 'package:flutter/material.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
@immutable
class LinkedInWebViewHandler extends StatefulWidget {
  const LinkedInWebViewHandler({
    required this.onUrlMatch,
    this.appBar,
    this.destroySession = false,
    this.onCookieClear,
    this.onWebViewCreated, // this is just for testing purpose
  });

  final bool? destroySession;
  final PreferredSizeWidget? appBar;
  final Function(WebViewController)? onWebViewCreated;
  final Function(DirectionUrlMatch) onUrlMatch;
  final Function(bool)? onCookieClear;

  @override
  State createState() => _LinkedInWebViewHandlerState();
}

class _LinkedInWebViewHandlerState extends State<LinkedInWebViewHandler> {
  WebViewController? webViewController;
  final CookieManager cookieManager = CookieManager();

  @override
  void initState() {
    super.initState();

    if (widget.destroySession!) {
      log('LinkedInAuth-steps: cache clearing... ');
      cookieManager.clearCookies().then((value) {
        widget.onCookieClear?.call(true);
        log('LinkedInAuth-steps: cache clearing... DONE');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = _ViewModel.from(context);
    return Scaffold(
      appBar: widget.appBar,
      body: Builder(
        builder: (BuildContext context) {
          return WebView(
            initialUrl: viewModel.initialUrl(),
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) async {
              log('LinkedInAuth-steps: onWebViewCreated ... ');

              widget.onWebViewCreated?.call(webViewController);

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
                widget.onUrlMatch(viewModel.getUrlConfiguration(request.url));
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
  }
}

@immutable
class _ViewModel {
  const _ViewModel._({
    required this.graph,
  });

  factory _ViewModel.from(BuildContext context) => _ViewModel._(
        graph: InjectorWidget.of(context),
      );

  final Graph? graph;

  DirectionUrlMatch getUrlConfiguration(String url) {
    final type = graph!.linkedInConfiguration is AccessCodeConfiguration
        ? WidgetType.fullProfile
        : WidgetType.authCode;
    return DirectionUrlMatch(url: url, type: type);
  }

  String initialUrl() => graph!.linkedInConfiguration.initialUrl;

  bool isUrlMatchingToRedirection(BuildContext context, String url) {
    return graph!.linkedInConfiguration.isCurrentUrlMatchToRedirection(url);
  }
}
