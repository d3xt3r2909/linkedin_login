import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/redux/actions.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/redux/core.dart';
import 'package:linkedin_login/src/client/state.dart';
import 'package:linkedin_login/src/server/state.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:redux/redux.dart';

import '../utils/mocks.dart';

void main() {
  Graph graph;
  Store<AppState> appStore;

  setUp(() {
    graph = MockGraph();
    appStore = MockStore();
  });

  test('reducer is called', () async {
    final state = reducer(AppState.initialState(), TestLinkedInAction());

    expect(state.userAuthCodeState, isA<UserAuthCodeState>());
    expect(state.linkedInUserState, isA<LinkedInUserState>());
  });

  test('LinkedInStore throws assertion error if store is null', () async {
    expect(
      () => LinkedInStore(
        graph: graph,
        store: null,
      ),
      throwsAssertionError,
    );
  });

  test('LinkedInStore throws assertion error if graph is null', () async {
    expect(
      () => LinkedInStore(
        graph: null,
        store: appStore,
      ),
      throwsAssertionError,
    );
  });

  test('store inject state', () async {
    final linkedInStore = LinkedInStore.inject(graph);

    expect(linkedInStore.store.state.linkedInUserState, isNotNull);
    expect(linkedInStore.store.state.userAuthCodeState, isNotNull);
    expect(linkedInStore.store.state.linkedInUserState.linkedInUser, isNull);
    expect(linkedInStore.store.state.userAuthCodeState.userAuthCode, isNull);
  });

  test('dispatchInitial - currently we are not using this function', () async {
    await LinkedInStore(graph: graph, store: appStore).dispatchInitial();
  });
}
