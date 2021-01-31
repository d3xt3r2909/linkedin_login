import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/server/linked_in_auth_code_widget.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';

import '../../../unit/utils/mocks.dart';
import '../../widget_test_utils.dart';

void main() {
  late Graph graph;
  late WidgetTestbed testbed;

  setUp(() {
    graph = MockGraph();

    testbed = WidgetTestbed(
      graph: graph,
    );
  });

  LinkedInAuthCodeWidget linkedInAuthCodeWidget({
    Function(AuthorizationCodeResponse)? onGetAuthCode,
    String redirectUrl = 'https://www.app.dexter.com',
    String clientId = '12345',
    String? frontendRedirectUrl,
    bool destroySession = false,
    AppBar? appBar,
  }) {
    return LinkedInAuthCodeWidget(
      onGetAuthCode: onGetAuthCode ?? (AuthorizationCodeResponse response) {},
      redirectUrl: redirectUrl,
      clientId: clientId,
      frontendRedirectUrl: frontendRedirectUrl,
      destroySession: destroySession,
      appBar: appBar,
    );
  }

  testWidgets('is created', (WidgetTester tester) async {
    linkedInAuthCodeWidget();
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

