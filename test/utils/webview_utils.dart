void main() {}
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/basic_types.dart';
// import 'package:flutter/src/gestures/recognizer.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
//
// import 'webview_utils.mocks.dart';
//
// const initialUrl =
//     'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=12345&state=null&redirect_uri=https://www.app.dexter.com&scope=r_liteprofile%20r_emailaddress';
//
// const urlAfterSuccessfulLogin =
//     'https://www.app.dexter.com/?code=AQQTwafddqnG27k6XUWiK0ONMAXKXPietjbeNtDeQGZnBVVM8vHlyrWFHysjGVCFfCAtNw0ajFCitY8fGMm53e7Had8ug0MO62quDLefdSZwNgOFzs6B5jdXgqUg_zad998th7ug4nAzXB71kD4EsYmqjhpUuCDjRNxu3FmRlGzMVOVHQhmEQwjitt0pBA&state=null';
//
// @GenerateMocks(<Type>[WebViewPlatform, WebViewPlatformController])
// void main() {}
//
// // This Widget ensures that onWebViewPlatformCreated is only called once when
// // making multiple calls to `WidgetTester.pumpWidget` with different parameters
// // for the WebView.
// class TestPlatformWebView extends StatefulWidget {
//   const TestPlatformWebView({
//     required final this.mockWebViewPlatformController,
//     final Key? key,
//     this.onWebViewPlatformCreated,
//   }) : super(key: key);
//
//   final MockWebViewPlatformController mockWebViewPlatformController;
//   final WebViewPlatformCreatedCallback? onWebViewPlatformCreated;
//
//   @override
//   State<StatefulWidget> createState() => TestPlatformWebViewState();
// }
//
// class TestPlatformWebViewState extends State<TestPlatformWebView> {
//   @override
//   void initState() {
//     super.initState();
//     final WebViewPlatformCreatedCallback? onWebViewPlatformCreated =
//         widget.onWebViewPlatformCreated;
//     if (onWebViewPlatformCreated != null) {
//       onWebViewPlatformCreated(widget.mockWebViewPlatformController);
//     }
//   }
//
//   @override
//   Widget build(final BuildContext context) {
//     return Container();
//   }
// }
//
// class MyWebViewPlatform implements WebViewPlatform {
//   MyWebViewPlatformController? lastPlatformBuilt;
//
//   @override
//   Widget build({
//     required final WebViewPlatformCallbacksHandler
//         webViewPlatformCallbacksHandler,
//     required final JavascriptChannelRegistry javascriptChannelRegistry,
//     final BuildContext? context,
//     final CreationParams? creationParams,
//     final WebViewPlatformCreatedCallback? onWebViewPlatformCreated,
//     final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
//   }) {
//     assert(onWebViewPlatformCreated != null);
//     lastPlatformBuilt = MyWebViewPlatformController(
//       creationParams,
//       gestureRecognizers,
//       webViewPlatformCallbacksHandler,
//     );
//     onWebViewPlatformCreated!(lastPlatformBuilt);
//     return Container();
//   }
//
//   @override
//   Future<bool> clearCookies() {
//     return Future<bool>.sync(() => true);
//   }
// }
//
// class MyWebViewPlatformController extends WebViewPlatformController {
//   MyWebViewPlatformController(
//     this.creationParams,
//     this.gestureRecognizers,
//     final WebViewPlatformCallbacksHandler platformHandler,
//   ) : super(platformHandler);
//
//   CreationParams? creationParams;
//   Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
//
//   String? lastUrlLoaded;
//   Map<String, String>? lastRequestHeaders;
//
//   @override
//   Future<void> loadUrl(
//     final String url,
//     final Map<String, String>? headers,
//   ) async {
//     equals(1, 1);
//     lastUrlLoaded = url;
//     lastRequestHeaders = headers;
//   }
// }
//
// class MatchesWebSettings extends Matcher {
//   MatchesWebSettings(this._webSettings);
//
//   final WebSettings? _webSettings;
//
//   @override
//   Description describe(final Description description) =>
//       description.add('$_webSettings');
//
//   @override
//   bool matches(
//     covariant final WebSettings webSettings,
//     final Map<dynamic, dynamic> matchState,
//   ) {
//     return _webSettings!.javascriptMode == webSettings.javascriptMode &&
//         _webSettings!.hasNavigationDelegate ==
//             webSettings.hasNavigationDelegate &&
//         _webSettings!.debuggingEnabled == webSettings.debuggingEnabled &&
//         _webSettings!.gestureNavigationEnabled ==
//             webSettings.gestureNavigationEnabled &&
//         _webSettings!.userAgent == webSettings.userAgent &&
//         _webSettings!.zoomEnabled == webSettings.zoomEnabled;
//   }
// }
//
// class MatchesCreationParams extends Matcher {
//   MatchesCreationParams(this._creationParams);
//
//   final CreationParams _creationParams;
//
//   @override
//   Description describe(final Description description) =>
//       description.add('$_creationParams');
//
//   @override
//   bool matches(
//     covariant final CreationParams creationParams,
//     final Map<dynamic, dynamic> matchState,
//   ) {
//     return _creationParams.initialUrl == creationParams.initialUrl &&
//         MatchesWebSettings(_creationParams.webSettings)
//             .matches(creationParams.webSettings!, matchState) &&
//         orderedEquals(_creationParams.javascriptChannelNames)
//             .matches(creationParams.javascriptChannelNames, matchState);
//   }
// }
//
// class MockWebViewCookieManagerPlatform extends WebViewCookieManagerPlatform {
//   List<WebViewCookie> setCookieCalls = <WebViewCookie>[];
//
//   @override
//   Future<bool> clearCookies() async => true;
//
//   @override
//   Future<void> setCookie(final WebViewCookie cookie) async {
//     setCookieCalls.add(cookie);
//   }
//
//   void reset() {
//     setCookieCalls = <WebViewCookie>[];
//   }
// }
