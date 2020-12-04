import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/client/linked_in_user_widget.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

import '../../../unit/utils/mocks.dart';
import '../../widget_test_utils.dart';

void main() {
  Store<AppState> store;
  Graph graph;
  List actions;
  WidgetTestbed testbed;
  _ArrangeBuilder builder;

  setUp(() {
    store = MockStore();
    graph = MockGraph();
    actions = [];

    builder = _ArrangeBuilder(store, graph, actions);

    testbed = WidgetTestbed(
      graph: graph,
      store: store,
      onReduction: builder.onReduction,
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
    final testWidget = testbed.reduxWrap(
      child: linkedInUserWidget(),
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    expect(find.text('AppBar title'), findsNothing);
  });

  testWidgets('App bar is shown if it is provided',
      (WidgetTester tester) async {
    final testWidget = testbed.reduxWrap(
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

class _ArrangeBuilder {
  _ArrangeBuilder(
    this.store,
    this.graph,
    this.actions, {
    Config configuration,
  }) : _configuration = configuration ?? MockConfiguration() {
    state = AppState.initialState();
    when(store.state).thenAnswer((_) => state);
    when(graph.linkedInConfiguration).thenAnswer((_) => _configuration);

    withConfiguration();
  }

  final Store<AppState> store;
  final List<dynamic> actions;
  final Graph graph;
  final Config _configuration;

  AppState state;

  AppState onReduction(dynamic event) {
    actions.add(event);

    return state;
  }

  void withConfiguration() {
    when(_configuration.initialUrl).thenAnswer((_) =>
        'https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=12345&state=null&redirect_uri=https://www.app.dexter.com&scope=r_liteprofile%20r_emailaddress');
  }

  void withUrlNotMatch() {
    when(_configuration.isCurrentUrlMatchToRedirection(any))
        .thenAnswer((_) => false);
  }

  void withUrlMatch() {
    when(_configuration.isCurrentUrlMatchToRedirection(any))
        .thenAnswer((_) => true);
  }
}
