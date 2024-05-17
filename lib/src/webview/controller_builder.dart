import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:linkedin_login/src/webview/linked_in_web_view_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewControllerBuilder {
  const WebViewControllerBuilder({
    required this.configuration,
  });

  final Config configuration;

  void clearCookies({
    final bool destroySession = false,
    final OnCookieClear onCookieClear,
  }) {
    final WebViewCookieManager cookieManager = WebViewCookieManager();

    if (destroySession) {
      log('LinkedInAuth-steps: cache clearing... ');
      cookieManager.clearCookies().then((final value) {
        onCookieClear?.call(true);
        log('LinkedInAuth-steps: cache clearing... DONE');
      });
    }
  }

  WebViewController controllerBuilder({
    required final OnUrlMatch onUrlMatch,
  }) {
    late final PlatformWebViewControllerCreationParams params;

    // iOS specific not web
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams();
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      // Should fix opening of keyboard on Android 13 since its using
      // [$AndroidViewSurface]
      params = AndroidWebViewControllerCreationParams();
    }

    return WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (final progress) {
            log('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (final url) {
            log('Page started loading: $url');
          },
          onPageFinished: (final url) {
            log('Page finished loading: $url');
          },
          onWebResourceError: (final error) {
            log('''
                  Page resource error:
                  code: ${error.errorCode}
                  description: ${error.description}
                  errorType: ${error.errorType}
                  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (final request) {
            log('LinkedInAuth-steps: navigationDelegate ... ');
            final isMatch = _isUrlMatchingToRedirection(request.url);
            log(
              'LinkedInAuth-steps: navigationDelegate '
              '[currentUrL: ${request.url}, isCurrentMatch: $isMatch]',
            );

            if (isMatch) {
              onUrlMatch(_getUrlConfiguration(request.url));
              log('Navigation delegate prevent... done');
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(_initialUrl());
  }

  bool _isUrlMatchingToRedirection(final String url) {
    return configuration.isCurrentUrlMatchToRedirection(url);
  }

  DirectionUrlMatch _getUrlConfiguration(final String url) {
    final type = configuration is AccessCodeConfiguration
        ? WidgetType.fullProfile
        : WidgetType.authCode;
    return DirectionUrlMatch(url: url, type: type);
  }

  Uri _initialUrl() => Uri.parse(configuration.initialUrl);
}
