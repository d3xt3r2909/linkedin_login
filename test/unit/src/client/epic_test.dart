import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/client/actions.dart';
import 'package:linkedin_login/src/client/epic.dart';
import 'package:linkedin_login/src/server/actions.dart';
import 'package:linkedin_login/src/server/epic.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/session.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../utils/mocks.dart';
import '../../utils/stream_utils.dart';

void main() {
  EpicStore<AppState> epicStore;

  setUp(() {
    final mockStore = MockStore();
    epicStore = EpicStore(mockStore);

    Session.clientState = Uuid().v4();
  });

  final urlAfterSuccessfulLogin =
      'https://www.app.dexter.com/?code=AQQTwafddqnG27k6XUWiK0ONMAXKXPietjbeNtDeQGZnBVVM8vHlyrWFHysjGVCFfCAtNw0ajFCitY8fGMm53e7Had8ug0MO62quDLefdSZwNgOFzs6B5jdXgqUg_zad998th7ug4nAzXB71kD4EsYmqjhpUuCDjRNxu3FmRlGzMVOVHQhmEQwjitt0pBA';

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

  test('Emits FetchAccessCodeFailedAction if state code is not valid',
      () async {
    final events = clientEpics()(
      toStream(
        DirectionUrlMatchSucceededAction(
          '$urlAfterSuccessfulLogin&state=null',
          config,
        ),
      ),
      epicStore,
    );

    expect(
      events,
      emits(
        FetchAccessCodeFailedAction(Exception()),
      ),
    );
  });

  test('Emits FetchAccessCodeSucceededAction on success', () async {
    final events = clientEpics()(
      toStream(
        DirectionUrlMatchSucceededAction(
          '$urlAfterSuccessfulLogin&state=${Session.clientState}',
          config,
        ),
      ),
      epicStore,
    );

    expect(
      events,
      emits(FetchAccessCodeSucceededAction(LinkedInTokenObject())),
    );
  });
}
