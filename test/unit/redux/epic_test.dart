import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/redux/epics.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:redux_epics/redux_epics.dart';

import '../utils/mocks.dart';

void main() {
  Graph graph;

  setUp(() {
    graph = MockGraph();
  });

  test('reducer is called', () async {
    final epicTester = epics(graph);

    expect(epicTester, isA<Epic<AppState>>());
  });
}
