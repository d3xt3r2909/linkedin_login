import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:linkedin_login/src/webview/linked_in_web_view_handler.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:redux/redux.dart';
import '../../../unit/utils/mocks.dart';
import '../../widget_test_utils.dart';

void main() {
  Store<AppState> store;
  List actions;
  WidgetTestbed testbed;
  _ArrangeBuilder builder;

  TestWidgetsFlutterBinding.ensureInitialized();
  final _FakeCookieManager _fakeCookieManager = _FakeCookieManager();
  final _FakePlatformViewsController fakePlatformViewsController =
      _FakePlatformViewsController();

  setUpAll(() {
    SystemChannels.platform_views.setMockMethodCallHandler(
        fakePlatformViewsController.fakePlatformViewsMethodHandler);
    SystemChannels.platform
        .setMockMethodCallHandler(_fakeCookieManager.onMethodCall);
  });

  setUp(() {
    store = MockStore();
    actions = [];

    fakePlatformViewsController.reset();
    _fakeCookieManager.reset();

    builder = _ArrangeBuilder(store, actions);

    testbed = WidgetTestbed(
      store: store,
      onReduction: builder.onReduction,
    );
  });

  final initialUrl =
      'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=12345&state=null&redirect_uri=https://www.app.dexter.com&scope=r_liteprofile%20r_emailaddress';

  final urlAfterSuccessfulLogin =
      'https://www.app.dexter.com/?code=AQQTwafddqnG27k6XUWiK0ONMAXKXPietjbeNtDeQGZnBVVM8vHlyrWFHysjGVCFfCAtNw0ajFCitY8fGMm53e7Had8ug0MO62quDLefdSZwNgOFzs6B5jdXgqUg_zad998th7ug4nAzXB71kD4EsYmqjhpUuCDjRNxu3FmRlGzMVOVHQhmEQwjitt0pBA&state=null';

  AccessCodeConfig configurationAccessCode({
    List<String> projectionParam,
    PreferredSizeWidget appBar,
  }) {
    return AccessCodeConfig(
      redirectUrl: 'https://www.app.dexter.com',
      clientId: '12345',
      clientSecretParam: 'somethingrandom',
      appBar: appBar,
      projectionParam: projectionParam ??
          const [
            ProjectionParameters.id,
            ProjectionParameters.localizedFirstName,
            ProjectionParameters.localizedLastName,
            ProjectionParameters.firstName,
            ProjectionParameters.lastName,
          ],
    );
  }

  testWidgets('is created', (WidgetTester tester) async {
    LinkedInWebViewHandler();
  });

  testWidgets('is not created when destroy session parameter is null',
      (WidgetTester tester) async {
    expect(
      () => LinkedInWebViewHandler(
        destroySession: null,
      ),
      throwsAssertionError,
    );
  });

  testWidgets('with app bar', (WidgetTester tester) async {
    final testWidget = testbed.reduxWrap(
      child: LinkedInWebViewHandler(
        appBar: AppBar(
          title: Text('Title'),
        ),
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsOneWidget);
  });

  testWidgets('test with initial url', (WidgetTester tester) async {
    WebViewController controller;
    final testWidget = testbed.reduxWrap(
      child: LinkedInWebViewHandler(
        onWebViewCreated: (webViewController) {
          controller = webViewController;
        },
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(await controller.currentUrl(), initialUrl);
  });

  testWidgets('test changing url if url does not match url',
      (WidgetTester tester) async {
    final testWidget = testbed.reduxWrap(
      child: LinkedInWebViewHandler(),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    final FakePlatformWebView platformWebView =
        fakePlatformViewsController.lastCreatedView;
    platformWebView.fakeNavigate('https://www.google.com');
    await tester.pump();

    expect(platformWebView.hasNavigationDelegate, true);
    expect(platformWebView.currentUrl, 'https://www.google.com');
    expect(actions.whereType<DirectionUrlMatch>(), hasLength(0));
  });

  testWidgets('emit proper action if url is matching if redirection',
      (WidgetTester tester) async {
    final testWidget = testbed.reduxWrap(
      child: LinkedInWebViewHandler(),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    final FakePlatformWebView platformWebView =
        fakePlatformViewsController.lastCreatedView;
    platformWebView.fakeNavigate(urlAfterSuccessfulLogin);
    await tester.pumpAndSettle();

    expect(actions.whereType<DirectionUrlMatch>(), hasLength(1));
  });
}

class _ArrangeBuilder {
  _ArrangeBuilder(
    this.store,
    this.actions,
  ) {
    state = AppState.initialState();
    when(store.state).thenAnswer((_) => state);
  }

  final Store<AppState> store;
  final List<dynamic> actions;

  AppState state;

  AppState onReduction(dynamic event) {
    actions.add(event);

    return state;
  }
}

class _FakePlatformViewsController {
  FakePlatformWebView lastCreatedView;

  Future<dynamic> fakePlatformViewsMethodHandler(MethodCall call) {
    switch (call.method) {
      case 'create':
        final Map<dynamic, dynamic> args = call.arguments;
        final Map<dynamic, dynamic> params = _decodeParams(args['params']);
        lastCreatedView = FakePlatformWebView(
          args['id'],
          params,
        );
        return Future<int>.sync(() => 1);
      default:
        return Future<void>.sync(() {});
    }
  }

  void reset() {
    lastCreatedView = null;
  }
}

class FakePlatformWebView {
  FakePlatformWebView(int id, Map<dynamic, dynamic> params) {
    if (params.containsKey('initialUrl')) {
      final String initialUrl = params['initialUrl'];
      if (initialUrl != null) {
        history.add(initialUrl);
        currentPosition++;
      }
    }
    if (params.containsKey('javascriptChannelNames')) {
      javascriptChannelNames =
          List<String>.from(params['javascriptChannelNames']);
    }
    javascriptMode = JavascriptMode.values[params['settings']['jsMode']];
    hasNavigationDelegate =
        params['settings']['hasNavigationDelegate'] ?? false;
    debuggingEnabled = params['settings']['debuggingEnabled'];
    userAgent = params['settings']['userAgent'];
    channel = MethodChannel(
        'plugins.flutter.io/webview_$id', const StandardMethodCodec());
    channel.setMockMethodCallHandler(onMethodCall);
  }

  MethodChannel channel;

  List<String> history = <String>[];
  int currentPosition = -1;
  int amountOfReloadsOnCurrentUrl = 0;
  bool hasCache = true;

  String get currentUrl => history.isEmpty ? null : history[currentPosition];
  JavascriptMode javascriptMode;
  List<String> javascriptChannelNames;

  bool hasNavigationDelegate;
  bool debuggingEnabled;
  String userAgent;

  Future<dynamic> onMethodCall(MethodCall call) {
    switch (call.method) {
      case 'loadUrl':
        final Map<dynamic, dynamic> request = call.arguments;
        _loadUrl(request['url']);
        return Future<void>.sync(() {});
      case 'updateSettings':
        if (call.arguments['jsMode'] != null) {
          javascriptMode = JavascriptMode.values[call.arguments['jsMode']];
        }
        if (call.arguments['hasNavigationDelegate'] != null) {
          hasNavigationDelegate = call.arguments['hasNavigationDelegate'];
        }
        if (call.arguments['debuggingEnabled'] != null) {
          debuggingEnabled = call.arguments['debuggingEnabled'];
        }
        userAgent = call.arguments['userAgent'];
        break;
      case 'canGoBack':
        return Future<bool>.sync(() => currentPosition > 0);
        break;
      case 'canGoForward':
        return Future<bool>.sync(() => currentPosition < history.length - 1);
        break;
      case 'goBack':
        currentPosition = max(-1, currentPosition - 1);
        return Future<void>.sync(() {});
        break;
      case 'goForward':
        currentPosition = min(history.length - 1, currentPosition + 1);
        return Future<void>.sync(() {});
      case 'reload':
        amountOfReloadsOnCurrentUrl++;
        return Future<void>.sync(() {});
        break;
      case 'currentUrl':
        return Future<String>.value(currentUrl);
        break;
      case 'evaluateJavascript':
        return Future<dynamic>.value(call.arguments);
        break;
      case 'addJavascriptChannels':
        final List<String> channelNames = List<String>.from(call.arguments);
        javascriptChannelNames.addAll(channelNames);
        break;
      case 'removeJavascriptChannels':
        final List<String> channelNames = List<String>.from(call.arguments);
        javascriptChannelNames
            .removeWhere((String channel) => channelNames.contains(channel));
        break;
      case 'clearCache':
        hasCache = false;
        return Future<void>.sync(() {});
    }
    return Future<void>.sync(() {});
  }

  void fakeJavascriptPostMessage(String jsChannel, String message) {
    final StandardMethodCodec codec = const StandardMethodCodec();
    final Map<String, dynamic> arguments = <String, dynamic>{
      'channel': jsChannel,
      'message': message
    };
    final ByteData data = codec
        .encodeMethodCall(MethodCall('javascriptChannelMessage', arguments));
    ServicesBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(channel.name, data, (ByteData data) {});
  }

  // Fakes a main frame navigation that was initiated by the webview, e.g when
  // the user clicks a link in the currently loaded page.
  void fakeNavigate(String url) {
    if (!hasNavigationDelegate) {
      print('no navigation delegate');
      _loadUrl(url);
      return;
    }
    final StandardMethodCodec codec = const StandardMethodCodec();
    final Map<String, dynamic> arguments = <String, dynamic>{
      'url': url,
      'isForMainFrame': true
    };
    final ByteData data =
        codec.encodeMethodCall(MethodCall('navigationRequest', arguments));
    ServicesBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(channel.name, data, (ByteData data) {
      final bool allow = codec.decodeEnvelope(data);
      if (allow) {
        _loadUrl(url);
      }
    });
  }

  void fakeOnPageStartedCallback() {
    final StandardMethodCodec codec = const StandardMethodCodec();

    final ByteData data = codec.encodeMethodCall(MethodCall(
      'onPageStarted',
      <dynamic, dynamic>{'url': currentUrl},
    ));

    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      data,
      (ByteData data) {},
    );
  }

  void fakeOnPageFinishedCallback() {
    final StandardMethodCodec codec = const StandardMethodCodec();

    final ByteData data = codec.encodeMethodCall(MethodCall(
      'onPageFinished',
      <dynamic, dynamic>{'url': currentUrl},
    ));

    ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      data,
      (ByteData data) {},
    );
  }

  void _loadUrl(String url) {
    history = history.sublist(0, currentPosition + 1);
    history.add(url);
    currentPosition++;
    amountOfReloadsOnCurrentUrl = 0;
  }
}

class _FakeCookieManager {
  _FakeCookieManager() {
    final MethodChannel channel = const MethodChannel(
      'plugins.flutter.io/cookie_manager',
      StandardMethodCodec(),
    );
    channel.setMockMethodCallHandler(onMethodCall);
  }

  bool hasCookies = true;

  Future<bool> onMethodCall(MethodCall call) {
    switch (call.method) {
      case 'clearCookies':
        bool hadCookies = false;
        if (hasCookies) {
          hadCookies = true;
          hasCookies = false;
        }
        return Future<bool>.sync(() {
          return hadCookies;
        });
        break;
    }
    return Future<bool>.sync(() => null);
  }

  void reset() {
    hasCookies = true;
  }
}

Map<dynamic, dynamic> _decodeParams(Uint8List paramsMessage) {
  final ByteBuffer buffer = paramsMessage.buffer;
  final ByteData messageBytes = buffer.asByteData(
    paramsMessage.offsetInBytes,
    paramsMessage.lengthInBytes,
  );
  return const StandardMessageCodec().decodeMessage(messageBytes);
}
