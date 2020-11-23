import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/server/actions.dart';
import 'package:linkedin_login/src/server/epic.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/session.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';
import 'package:mockito/mockito.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../utils/mocks.dart';
import '../../utils/stream_utils.dart';

void main() {
  EpicStore<AppState> store;
  Graph graph;
  _ArrangeBuilder builder;

  setUp(() {
    final mockStore = MockStore();
    graph = MockGraph();
    store = EpicStore(mockStore);

    final authorizationRepository = MockAuthorizationRepository();
    final userRepository = MockUserRepository();

    builder = _ArrangeBuilder(
      graph,
      store,
      authorizationRepository,
      userRepository,
    );

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

  test('Emits FetchAuthCodeFailedAction if state code is not valid', () async {
    final exception = Exception();
    builder.withAuthCodeError(exception);

    final events = serverEpics(graph)(
      toStream(
        DirectionUrlMatchSucceededAction(
          '$urlAfterSuccessfulLogin&state=null',
        ),
      ),
      store,
    );

    expect(
      events,
      emits(
        FetchAuthCodeFailedAction(exception),
      ),
    );
  });

  test('Emits FetchAuthCodeSucceededAction on success', () async {
    builder.withAuthCode();

    final events = serverEpics(graph)(
      toStream(
        DirectionUrlMatchSucceededAction(
          '$urlAfterSuccessfulLogin&state=${Session.clientState}',
        ),
      ),
      store,
    );

    expect(
      events,
      emits(FetchAuthCodeSucceededAction(AuthorizationCodeResponse())),
    );
  });
}

class _ArrangeBuilder {
  _ArrangeBuilder(
    this.graph,
    this.store,
    this.authorizationRepository,
    this.userRepository,
  ) : api = MockApi() {
    when(graph.api).thenReturn(api);
    when(graph.authorizationRepository).thenReturn(authorizationRepository);
    when(graph.userRepository).thenReturn(userRepository);
  }

  final Graph graph;
  final LinkedInApi api;
  final AuthorizationRepository authorizationRepository;
  final UserRepository userRepository;
  final EpicStore<AppState> store;

  void withAuthCode() {
    when(authorizationRepository.fetchAuthorizationCode(
      redirectedUrl: anyNamed('redirectedUrl'),
    )).thenAnswer(
      (_) => AuthorizationCodeResponse(
        state: 'state',
        code: 'code',
      ),
    );
  }

  void withAuthCodeError([Exception exception]) {
    when(authorizationRepository.fetchAuthorizationCode(
      redirectedUrl: anyNamed('redirectedUrl'),
    )).thenThrow(exception ?? Exception());
  }
}
