import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/actions.dart';
import 'package:linkedin_login/src/client/linked_in_user_widget.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';

import '../../../unit/utils/shared_mocks.mocks.dart';
import '../../widget_test_utils.dart';

void main() {
  Graph graph;
  late WidgetTestbed testbed;

  setUp(() {
    graph = MockGraph();

    testbed = WidgetTestbed(
      graph: graph,
    );
  });

  LinkedInUserWidget linkedInUserWidget({
    Function(UserSucceededAction)? onGetUserProfile,
    String? redirectUrl = 'https://www.app.dexter.com',
    String? clientId = '12345',
    String? clientSecret = '56789',
    String? frontendRedirectUrl,
    bool? destroySession = false,
    AppBar? appBar,
    List<String> projection = const [
      ProjectionParameters.id,
      ProjectionParameters.localizedFirstName,
      ProjectionParameters.localizedLastName,
      ProjectionParameters.firstName,
      ProjectionParameters.lastName,
    ],
  }) {
    return LinkedInUserWidget(
      onGetUserProfile: onGetUserProfile ?? (UserSucceededAction response) {},
      redirectUrl: redirectUrl,
      clientId: clientId,
      destroySession: destroySession,
      appBar: appBar,
      clientSecret: clientSecret,
      projection: projection,
      onError: (UserFailedAction e) {},
    );
  }

  testWidgets('is created', (WidgetTester tester) async {
    linkedInUserWidget();
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
