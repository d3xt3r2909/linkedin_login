import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/actions.dart';
import 'package:linkedin_login/src/server/linked_in_auth_code_widget.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';

import '../../../unit/utils/mocks.dart';
import '../../widget_test_utils.dart';

void main() {
  Graph graph;
  WidgetTestbed testbed;

  setUp(() {
    graph = MockGraph();

    testbed = WidgetTestbed(
      graph: graph,
    );
  });

  LinkedInAuthCodeWidget linkedInAuthCodeWidget({
    Function(AuthorizationSucceededAction) onGetAuthCode,
    String redirectUrl = 'https://www.app.dexter.com',
    String clientId = '12345',
    String frontendRedirectUrl,
    bool destroySession = false,
    AppBar appBar,
  }) {
    return LinkedInAuthCodeWidget(
      onGetAuthCode:
          onGetAuthCode ?? (AuthorizationSucceededAction response) {},
      redirectUrl: redirectUrl,
      clientId: clientId,
      frontendRedirectUrl: frontendRedirectUrl,
      destroySession: destroySession,
      appBar: appBar,
      onError: (AuthorizationFailedAction e) {},
    );
  }

  testWidgets('is created', (WidgetTester tester) async {
    linkedInAuthCodeWidget();
  });

  testWidgets('is not created when onGetAuthCode callback is null',
      (WidgetTester tester) async {
    expect(
      () => LinkedInAuthCodeWidget(
        onGetAuthCode: null,
        redirectUrl: '',
        clientId: '',
        onError: (AuthorizationFailedAction e) {},
      ),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when redirectUrl is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInAuthCodeWidget(redirectUrl: null),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when clientId is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInAuthCodeWidget(clientId: null),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when destroySession is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInAuthCodeWidget(destroySession: null),
      throwsAssertionError,
    );
  });

  testWidgets('App bar is not shown if not provided',
      (WidgetTester tester) async {
    final testWidget = testbed.simpleWrap(
      child: linkedInAuthCodeWidget(),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(find.text('AppBar title'), findsNothing);
  });

  testWidgets('App bar is shown if it is provided',
      (WidgetTester tester) async {
    final testWidget = testbed.simpleWrap(
      child: linkedInAuthCodeWidget(
        appBar: AppBar(
          title: Text('AppBar title'),
        ),
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(find.text('AppBar title'), findsOneWidget);
  });
}
