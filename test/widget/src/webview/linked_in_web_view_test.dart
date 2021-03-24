import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:linkedin_login/src/webview/linked_in_web_view_handler.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../unit/utils/shared_mocks.mocks.dart';
import '../../widget_test_utils.dart';

void main() {
  Graph graph;
  List? actions;
  late WidgetTestbed testbed;
  late _ArrangeBuilder builder;

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
    graph = MockGraph();
    actions = [];

    fakePlatformViewsController.reset();
    _fakeCookieManager.reset();

    builder = _ArrangeBuilder(graph, actions);

    testbed = WidgetTestbed(
      graph: graph,
    );
  });

  testWidgets('is created', (WidgetTester tester) async {
    LinkedInWebViewHandler(
      onUrlMatch: (_) {},
    );
  });

  testWidgets('with app bar', (WidgetTester tester) async {
    final testWidget = testbed.injectWrap(
      child: LinkedInWebViewHandler(
        appBar: AppBar(
          title: Text('Title'),
        ),
        onUrlMatch: (_) {},
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsOneWidget);
  });

  testWidgets('test with initial url', (WidgetTester tester) async {
    late WebViewController controller;
    final testWidget = testbed.injectWrap(
      child: LinkedInWebViewHandler(
        onWebViewCreated: (webViewController) {
          controller = webViewController;
        },
        onUrlMatch: (_) {},
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(await controller.currentUrl(), initialUrl);
  });

  testWidgets('test changing url if url does not match url',
      (WidgetTester tester) async {
    builder.withUrlNotMatch('https://www.google.com');
    final testWidget = testbed.injectWrap(
      child: LinkedInWebViewHandler(
        onUrlMatch: (_) {},
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    final platformWebView = fakePlatformViewsController.lastCreatedView!
      ..fakeNavigate('https://www.google.com');
    await tester.pump();

    expect(platformWebView.hasNavigationDelegate, true);
    expect(platformWebView.currentUrl, 'https://www.google.com');
    expect(actions!.whereType<DirectionUrlMatch>(), hasLength(0));
  });

  testWidgets(
      'callback for cookie clear is called when destroying session is active',
      (WidgetTester tester) async {
    var isCleared = false;
    final testWidget = testbed.injectWrap(
      child: LinkedInWebViewHandler(
        destroySession: true,
        onCookieClear: (value) => isCleared = value,
        onUrlMatch: (_) {},
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(isCleared, isTrue);
  });

  testWidgets(
      'callback for cookie clearing is not called when destroying session is inactive',
      (WidgetTester tester) async {
    var isCleared = false;
    final testWidget = testbed.injectWrap(
      child: LinkedInWebViewHandler(
        destroySession: false,
        onCookieClear: (value) => isCleared = value,
        onUrlMatch: (_) {},
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(isCleared, isFalse);
  });
}

const initialUrl =
    'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=12345&state=null&redirect_uri=https://www.app.dexter.com&scope=r_liteprofile%20r_emailaddress';

const urlAfterSuccessfulLogin =
    'https://www.app.dexter.com/?code=AQQTwafddqnG27k6XUWiK0ONMAXKXPietjbeNtDeQGZnBVVM8vHlyrWFHysjGVCFfCAtNw0ajFCitY8fGMm53e7Had8ug0MO62quDLefdSZwNgOFzs6B5jdXgqUg_zad998th7ug4nAzXB71kD4EsYmqjhpUuCDjRNxu3FmRlGzMVOVHQhmEQwjitt0pBA&state=null';

class _ArrangeBuilder {
  _ArrangeBuilder(
    this.graph,
    this.actions, {
    Config? configuration,
  }) : _configuration = configuration ?? MockConfig() {
    when(graph.linkedInConfiguration).thenAnswer((_) => _configuration);

    withConfiguration();
  }

  final List<dynamic>? actions;
  final Graph graph;
  final Config _configuration;

  void withConfiguration() {
    when(_configuration.initialUrl).thenAnswer((_) =>
        'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=12345&state=null&redirect_uri=https://www.app.dexter.com&scope=r_liteprofile%20r_emailaddress');
  }

  void withUrlNotMatch(String url) {
    when(_configuration.isCurrentUrlMatchToRedirection(url))
        .thenAnswer((_) => false);
  }

  void withUrlMatch(String url) {
    when(_configuration.isCurrentUrlMatchToRedirection(url))
        .thenAnswer((_) => true);
  }
}

class _FakePlatformViewsController {
  FakePlatformWebView? lastCreatedView;

  Future<dynamic> fakePlatformViewsMethodHandler(MethodCall call) {
    switch (call.method) {
      case 'create':
        final Map<dynamic, dynamic> args = call.arguments;
        final Map<dynamic, dynamic> params = _decodeParams(args['params'])!;
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
  FakePlatformWebView(int? id, Map<dynamic, dynamic> params) {
    if (params.containsKey('initialUrl')) {
      final String? initialUrl = params['initialUrl'];
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
        'plugins.flutter.io/webview_$id', const StandardMethodCodec())
      ..setMockMethodCallHandler(onMethodCall);
  }

  late MethodChannel channel;

  List<String?> history = <String?>[];
  int currentPosition = -1;
  int amountOfReloadsOnCurrentUrl = 0;
  bool hasCache = true;

  String? get currentUrl => history.isEmpty ? null : history[currentPosition];
  JavascriptMode? javascriptMode;
  late List<String> javascriptChannelNames;

  bool? hasNavigationDelegate;
  bool? debuggingEnabled;
  String? userAgent;

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
      case 'canGoForward':
        return Future<bool>.sync(() => currentPosition < history.length - 1);
      case 'goBack':
        currentPosition = max(-1, currentPosition - 1);
        return Future<void>.sync(() {});
      case 'goForward':
        currentPosition = min(history.length - 1, currentPosition + 1);
        return Future<void>.sync(() {});
      case 'reload':
        amountOfReloadsOnCurrentUrl++;
        return Future<void>.sync(() {});
      case 'currentUrl':
        return Future<String>.value(currentUrl);
      case 'evaluateJavascript':
        return Future<dynamic>.value(call.arguments);
      case 'addJavascriptChannels':
        final List<String> channelNames = List<String>.from(call.arguments);
        javascriptChannelNames.addAll(channelNames);
        break;
      case 'removeJavascriptChannels':
        final List<String> channelNames = List<String>.from(call.arguments);
        javascriptChannelNames.removeWhere(channelNames.contains);
        break;
      case 'clearCache':
        hasCache = false;
        return Future<void>.sync(() {});
    }
    return Future<void>.sync(() {});
  }

  void fakeJavascriptPostMessage(String jsChannel, String message) {
    const codec = const StandardMethodCodec();
    final arguments = <String, dynamic>{
      'channel': jsChannel,
      'message': message
    };
    final data = codec
        .encodeMethodCall(MethodCall('javascriptChannelMessage', arguments));
    ServicesBinding.instance!.defaultBinaryMessenger
        .handlePlatformMessage(channel.name, data, (ByteData? data) {});
  }

  // Fakes a main frame navigation that was initiated by the webview, e.g when
  // the user clicks a link in the currently loaded page.
  void fakeNavigate(String url) {
    if (!hasNavigationDelegate!) {
      _loadUrl(url);
      return;
    }
    const StandardMethodCodec codec = const StandardMethodCodec();
    final Map<String, dynamic> arguments = <String, dynamic>{
      'url': url,
      'isForMainFrame': true
    };
    final ByteData data =
        codec.encodeMethodCall(MethodCall('navigationRequest', arguments));
    ServicesBinding.instance!.defaultBinaryMessenger
        .handlePlatformMessage(channel.name, data, (ByteData? data) {
      final bool allow = codec.decodeEnvelope(data!);
      if (allow) {
        _loadUrl(url);
      }
    });
  }

  void fakeOnPageStartedCallback() {
    const StandardMethodCodec codec = const StandardMethodCodec();

    final ByteData data = codec.encodeMethodCall(MethodCall(
      'onPageStarted',
      <dynamic, dynamic>{'url': currentUrl},
    ));

    ServicesBinding.instance!.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      data,
      (ByteData? data) {},
    );
  }

  void fakeOnPageFinishedCallback() {
    const codec = const StandardMethodCodec();

    final ByteData data = codec.encodeMethodCall(MethodCall(
      'onPageFinished',
      <dynamic, dynamic>{'url': currentUrl},
    ));

    ServicesBinding.instance!.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      data,
      (ByteData? data) {},
    );
  }

  void _loadUrl(String? url) {
    history = history
      ..sublist(0, currentPosition + 1)
      ..add(url);
    currentPosition++;
    amountOfReloadsOnCurrentUrl = 0;
  }
}

class _FakeCookieManager {
  _FakeCookieManager() {
    const MethodChannel(
      'plugins.flutter.io/cookie_manager',
      StandardMethodCodec(),
    ).setMockMethodCallHandler(onMethodCall);
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
    }
    return Future<bool>.sync(() => false);
  }

  void reset() {
    hasCookies = true;
  }
}

Map<dynamic, dynamic>? _decodeParams(Uint8List paramsMessage) {
  final ByteBuffer buffer = paramsMessage.buffer;
  final ByteData messageBytes = buffer.asByteData(
    paramsMessage.offsetInBytes,
    paramsMessage.lengthInBytes,
  );
  return const StandardMessageCodec().decodeMessage(messageBytes);
}
