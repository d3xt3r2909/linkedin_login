import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/client/actions.dart';
import 'package:linkedin_login/src/server/actions.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:linkedin_login/src/webview/epic.dart';
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

  test('Emits succeeded on DirectionUrlMatch & FetchAccessCode action',
      () async {
    final events = webViewEpics(graph)(
      toStream(
        DirectionUrlMatch(
          urlAfterSuccessfulLogin,
          WidgetType.full_profile,
        ),
      ),
      epicStore,
    );

    expect(
      events,
      emitsInOrder(
        [
          FetchAccessCode(urlAfterSuccessfulLogin),
          DirectionUrlMatchSucceededAction(urlAfterSuccessfulLogin),
        ],
      ),
    );
  });

  test('Emits succeeded on DirectionUrlMatch action', () async {
    final events = webViewEpics(graph)(
      toStream(
        DirectionUrlMatch(
          urlAfterSuccessfulLogin,
          WidgetType.auth_code,
        ),
      ),
      epicStore,
    );

    expect(
      events,
      emitsInOrder(
        [
          FetchAuthCode(urlAfterSuccessfulLogin),
          DirectionUrlMatchSucceededAction(urlAfterSuccessfulLogin),
        ],
      ),
    );
  });
}
