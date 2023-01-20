import 'package:flutter/material.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef OnUrlMatch = ValueChanged<DirectionUrlMatch>;
typedef OnCookieClear = ValueChanged<bool>?;

/// Class will fetch code and access token from the user
/// It will show web view so that we can access to linked in auth page
@immutable
class LinkedInWebViewHandler extends StatelessWidget {
  const LinkedInWebViewHandler({
    required this.onUrlMatch,
    this.appBar,
    this.destroySession = false,
    this.onCookieClear,
    this.useVirtualDisplay = false,
    final Key? key,
  }) : super(key: key);

  final bool destroySession;
  final PreferredSizeWidget? appBar;
  final OnUrlMatch onUrlMatch;
  final OnCookieClear onCookieClear;
  final bool useVirtualDisplay;

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Builder(
        builder: (final BuildContext context) {
          final controller = InjectorWidget.of(context).webViewControllerBuilder
            ..clearCookies(
              destroySession: destroySession,
              onCookieClear: onCookieClear,
            );

          return WebViewWidget(
            controller: controller.controllerBuilder(
              onUrlMatch: onUrlMatch,
            ),
          );
        },
      ),
    );
  }
}
