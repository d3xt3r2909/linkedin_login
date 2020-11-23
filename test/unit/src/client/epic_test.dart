import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/client/actions.dart';
import 'package:linkedin_login/src/client/epic.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:linkedin_login/src/webview/web_view_widget_parameters.dart';
import 'package:mockito/mockito.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:test/test.dart';

import '../../utils/mocks.dart';
import '../../utils/stream_utils.dart';

void main() {
  EpicStore<AppState> store;
  Graph graph;
  _ArrangeBuilder builder;

  setUp(() {
    graph = MockGraph();
    final mockStore = MockStore();
    store = EpicStore(mockStore);
    final authorizationRepository = MockAuthorizationRepository();
    final userRepository = MockUserRepository();

    builder = _ArrangeBuilder(
      graph,
      store,
      authorizationRepository,
      userRepository,
    );
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
    final exception = Exception();
    builder.withAccessCodeError(exception);

    final events = clientEpics(graph)(
      toStream(
        DirectionUrlMatchSucceededAction('$urlAfterSuccessfulLogin&state=null'),
      ),
      store,
    );

    expect(
      events,
      emits(
        FetchAccessCodeFailedAction(exception),
      ),
    );
  });

  test('Emits FetchAccessCodeSucceededAction on success', () async {
    builder.withAccessCode();
    final events = clientEpics(graph)(
      toStream(
        DirectionUrlMatchSucceededAction(
          '$urlAfterSuccessfulLogin&state=state',
        ),
      ),
      store,
    );

    expect(
      events,
      emits(
        FetchAccessCodeSucceededAction(
          LinkedInTokenObject(accessToken: 'accessToken'),
        ),
      ),
    );
  });

  test(
      'Emits FetchLinkedInUserFailedAction if fetchFullProfile throws exception',
      () async {
    final exception = Exception();
    builder.withFullProfileError();

    final events = clientEpics(graph)(
      toStream(
        FetchAccessCodeSucceededAction(
          LinkedInTokenObject(accessToken: 'accessToken'),
        ),
      ),
      store,
    );

    expect(
      events,
      emits(
        FetchLinkedInUserFailedAction(exception),
      ),
    );
  });

  test('Emits FetchLinkedInUserSucceededAction on success', () async {
    builder.withFullProfile();
    final events = clientEpics(graph)(
      toStream(
        FetchAccessCodeSucceededAction(
          LinkedInTokenObject(accessToken: 'accessToken'),
        ),
      ),
      store,
    );

    expect(
      events,
      emits(
        FetchLinkedInUserSucceededAction(
          LinkedInUserModel(),
        ),
      ),
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

  void withAccessCode() {
    when(authorizationRepository.fetchAccessTokenCode(
            redirectedUrl: anyNamed('redirectedUrl'),
            clientSecret: anyNamed('clientSecret'),
            clientId: anyNamed('clientId'),
            clientState: anyNamed('clientState')))
        .thenAnswer((_) async => AuthorizationCodeResponse(
              state: 'state',
              code: 'code',
              accessToken: LinkedInTokenObject(
                accessToken: 'accessToken',
                expiresIn: 0,
              ),
            ));
  }

  void withAccessCodeError([Exception exception]) {
    when(authorizationRepository.fetchAccessTokenCode(
      redirectedUrl: anyNamed('redirectedUrl'),
      clientSecret: anyNamed('clientSecret'),
      clientId: anyNamed('clientId'),
      clientState: anyNamed('clientState'),
    )).thenThrow(exception ?? Exception());
  }

  void withFullProfileError([Exception exception]) {
    when(userRepository.fetchFullProfile(
      token: anyNamed('token'),
    )).thenThrow(exception ?? Exception());
  }

  void withFullProfile() {
    when(userRepository.fetchFullProfile(
      token: anyNamed('token'),
    )).thenAnswer((_) async => LinkedInUserModel());
  }
}
