import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/client/linked_in_user_widget.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:linkedin_login/src/utils/constants.dart';
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

  LinkedInUserWidget linkedInUserWidget({
    Function(LinkedInUserModel) onGetUserProfile,
    String redirectUrl = 'https://www.app.dexter.com',
    String clientId = '12345',
    String clientSecret = '56789',
    String frontendRedirectUrl,
    bool destroySession = false,
    AppBar appBar,
    List<String> projection = const [
      ProjectionParameters.id,
      ProjectionParameters.localizedFirstName,
      ProjectionParameters.localizedLastName,
      ProjectionParameters.firstName,
      ProjectionParameters.lastName,
    ],
  }) {
    return LinkedInUserWidget(
      onGetUserProfile: onGetUserProfile ?? (LinkedInUserModel response) {},
      redirectUrl: redirectUrl,
      clientId: clientId,
      destroySession: destroySession,
      appBar: appBar,
      clientSecret: clientSecret,
      projection: projection,
    );
  }

  testWidgets('is created', (WidgetTester tester) async {
    linkedInUserWidget();
  });

  testWidgets('is not created when onGetUserProfile callback is null',
      (WidgetTester tester) async {
    expect(
      () => LinkedInUserWidget(
        onGetUserProfile: null,
        redirectUrl: 'redirectUrl',
        clientId: 'clientId',
        clientSecret: 'clientSecret',
      ),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when redirectUrl is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInUserWidget(redirectUrl: null),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when clientId is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInUserWidget(clientId: null),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when destroySession is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInUserWidget(destroySession: null),
      throwsAssertionError,
    );
  });

  testWidgets('is not created when clientSecret is null',
      (WidgetTester tester) async {
    expect(
      () => linkedInUserWidget(clientSecret: null),
      throwsAssertionError,
    );
  });

  testWidgets('App bar is not shown if not provided',
      (WidgetTester tester) async {
    final testWidget = testbed.simpleWrap(
      child: linkedInUserWidget(),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(find.text('AppBar title'), findsNothing);
  });

  testWidgets('App bar is shown if it is provided',
      (WidgetTester tester) async {
    final testWidget = testbed.simpleWrap(
      child: linkedInUserWidget(
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
