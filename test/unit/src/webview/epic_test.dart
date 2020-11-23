import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:linkedin_login/src/webview/epic.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:test/test.dart';

import '../../utils/mocks.dart';
import '../../utils/stream_utils.dart';

void main() {
  EpicStore<AppState> epicStore;
  Graph graph;

  setUp(() {
    final mockStore = MockStore();
    epicStore = EpicStore(mockStore);
    graph = MockGraph();
  });

  final urlAfterSuccessfulLogin =
      'https://www.app.dexter.com/?code=AQQTwafddqnG27k6XUWiK0ONMAXKXPietjbeNtDeQGZnBVVM8vHlyrWFHysjGVCFfCAtNw0ajFCitY8fGMm53e7Had8ug0MO62quDLefdSZwNgOFzs6B5jdXgqUg_zad998th7ug4nAzXB71kD4EsYmqjhpUuCDjRNxu3FmRlGzMVOVHQhmEQwjitt0pBA&state=null';

  final config = AccessCodeConfig(
    redirectUrl: 'https://www.app.dexter.com',
    clientId: '12345',
    clientSecretParam: 'somethingrandom',
    projectionParam: const [
      ProjectionParameters.id,
      ProjectionParameters.localizedFirstName,
      ProjectionParameters.localizedLastName,
      ProjectionParameters.firstName,
      ProjectionParameters.lastName,
    ],
  );

  test('Emits succeeded on DirectionUrlMatch action', () async {
    final events = webViewEpics(graph)(
      toStream(DirectionUrlMatch(urlAfterSuccessfulLogin)),
      epicStore,
    );

    expect(
      events,
      emits(
        DirectionUrlMatchSucceededAction(urlAfterSuccessfulLogin),
      ),
    );
  });
}
