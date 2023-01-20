void main() {}
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:linkedin_login/linkedin_login.dart';
// import 'package:linkedin_login/src/utils/startup/graph.dart';
// import 'package:mockito/mockito.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
//
// import '../../../unit/utils/shared_mocks.mocks.dart';
// import '../../../utils/webview_utils.dart';
// import '../../../utils/webview_utils.mocks.dart';
// import '../../widget_test_utils.dart';
//
// void main() {
//   Graph graph;
//   late WidgetTestbed testbed;
//
//   TestWidgetsFlutterBinding.ensureInitialized();
//   late MockWebViewPlatform mockWebViewPlatform;
//   late MockWebViewPlatformController mockWebViewPlatformController;
//   late MockWebViewCookieManagerPlatform mockWebViewCookieManagerPlatform;
//
//   setUp(() {
//     graph = MockGraph();
//
//     testbed = WidgetTestbed(
//       graph: graph,
//     );
//   });
//
//   setUp(() {
//     mockWebViewPlatformController = MockWebViewPlatformController();
//     mockWebViewPlatform = MockWebViewPlatform();
//     mockWebViewCookieManagerPlatform = MockWebViewCookieManagerPlatform();
//
//     when(
//       mockWebViewPlatform.build(
//         context: anyNamed('context'),
//         creationParams: anyNamed('creationParams'),
//         webViewPlatformCallbacksHandler:
//             anyNamed('webViewPlatformCallbacksHandler'),
//         javascriptChannelRegistry: anyNamed('javascriptChannelRegistry'),
//         onWebViewPlatformCreated: anyNamed('onWebViewPlatformCreated'),
//         gestureRecognizers: anyNamed('gestureRecognizers'),
//       ),
//     ).thenAnswer((final Invocation invocation) {
//       final WebViewPlatformCreatedCallback onWebViewPlatformCreated =
//           invocation.namedArguments[const Symbol('onWebViewPlatformCreated')]
//               as WebViewPlatformCreatedCallback;
//       return TestPlatformWebView(
//         mockWebViewPlatformController: mockWebViewPlatformController,
//         onWebViewPlatformCreated: onWebViewPlatformCreated,
//       );
//     });
//
//     when(mockWebViewPlatformController.currentUrl())
//         .thenAnswer((final realInvocation) => Future.value(initialUrl));
//
//     WebView.platform = mockWebViewPlatform;
//     WebViewCookieManagerPlatform.instance = mockWebViewCookieManagerPlatform;
//
//     graph = MockGraph();
//
//     testbed = WidgetTestbed(
//       graph: graph,
//     );
//   });
//
//   LinkedInAuthCodeWidget linkedInAuthCodeWidget({
//     final ValueChanged<AuthorizationSucceededAction>? onGetAuthCode,
//     final String? redirectUrl = 'https://www.app.dexter.com',
//     final String? clientId = '12345',
//     final String? frontendRedirectUrl,
//     final bool? destroySession = false,
//     final AppBar? appBar,
//   }) {
//     return LinkedInAuthCodeWidget(
//       onGetAuthCode:
//           onGetAuthCode ?? (final AuthorizationSucceededAction response) {},
//       redirectUrl: redirectUrl,
//       clientId: clientId,
//       frontendRedirectUrl: frontendRedirectUrl,
//       destroySession: destroySession,
//       appBar: appBar,
//       onError: (final AuthorizationFailedAction e) {},
//     );
//   }
//
//   testWidgets('is created', (final WidgetTester tester) async {
//     linkedInAuthCodeWidget();
//   });
//
//   testWidgets('App bar is not shown if not provided',
//       (final WidgetTester tester) async {
//     final testWidget = testbed.simpleWrap(
//       child: linkedInAuthCodeWidget(),
//     );
//
//     await tester.pumpWidget(testWidget);
//     await tester.pumpAndSettle();
//
//     expect(find.text('AppBar title'), findsNothing);
//   });
//
//   testWidgets('App bar is shown if it is provided',
//       (final WidgetTester tester) async {
//     final testWidget = testbed.simpleWrap(
//       child: linkedInAuthCodeWidget(
//         appBar: AppBar(
//           title: const Text('AppBar title'),
//         ),
//       ),
//     );
//
//     await tester.pumpWidget(testWidget);
//     await tester.pumpAndSettle();
//
//     expect(find.text('AppBar title'), findsOneWidget);
//   });
// }
