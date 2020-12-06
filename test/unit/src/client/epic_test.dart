import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/client/actions.dart';
import 'package:linkedin_login/src/client/epic.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
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
    final configuration = MockConfiguration();

    builder = _ArrangeBuilder(
        graph, store, authorizationRepository, userRepository, configuration);
  });

  const urlAfterSuccessfulLogin =
      'https://www.app.dexter.com/?code=AQQTwafddqnG27k6XUWiK0ONMAXKXPietjbeNtDeQGZnBVVM8vHlyrWFHysjGVCFfCAtNw0ajFCitY8fGMm53e7Had8ug0MO62quDLefdSZwNgOFzs6B5jdXgqUg_zad998th7ug4nAzXB71kD4EsYmqjhpUuCDjRNxu3FmRlGzMVOVHQhmEQwjitt0pBA';

  test('Emits FetchAccessCodeFailedAction if state code is not valid',
      () async {
    final exception = Exception();
    builder.withAccessCodeError(exception);

    final events = clientEpics(graph)(
      toStream(
        FetchAccessCode('$urlAfterSuccessfulLogin&state=null'),
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
        FetchAccessCode(
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

    final action = FetchLinkedInUser(
      LinkedInTokenObject(accessToken: 'accessToken'),
    );

    // ignore: avoid_print
    print(action.toString());

    final events = clientEpics(graph)(
      toStream(action),
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
        FetchLinkedInUser(
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
    this.configuration,
  ) : api = MockApi() {
    when(graph.api).thenReturn(api);
    when(graph.authorizationRepository).thenReturn(authorizationRepository);
    when(graph.linkedInConfiguration).thenReturn(configuration);
    when(graph.userRepository).thenReturn(userRepository);

    withConfiguration();
  }

  final Graph graph;
  final LinkedInApi api;
  final AuthorizationRepository authorizationRepository;
  final UserRepository userRepository;
  final Config configuration;
  final EpicStore<AppState> store;

  void withAccessCode() {
    when(authorizationRepository.fetchAccessTokenCode(
      redirectedUrl: anyNamed('redirectedUrl'),
      clientSecret: anyNamed('clientSecret'),
      clientId: anyNamed('clientId'),
      clientState: anyNamed('clientState'),
      client: anyNamed('client'),
    )).thenAnswer(
      (_) async => AuthorizationCodeResponse(
        state: 'state',
        code: 'code',
        accessToken: LinkedInTokenObject(
          accessToken: 'accessToken',
          expiresIn: 0,
        ),
      ),
    );
  }

  void withAccessCodeError([Exception exception]) {
    when(authorizationRepository.fetchAccessTokenCode(
      redirectedUrl: anyNamed('redirectedUrl'),
      clientSecret: anyNamed('clientSecret'),
      clientId: anyNamed('clientId'),
      clientState: anyNamed('clientState'),
      client: anyNamed('client'),
    )).thenThrow(exception ?? Exception());
  }

  void withFullProfileError([Exception exception]) {
    when(userRepository.fetchFullProfile(
      token: anyNamed('token'),
      projection: anyNamed('projection'),
      client: anyNamed('client'),
    )).thenThrow(exception ?? Exception());
  }

  void withFullProfile() {
    when(userRepository.fetchFullProfile(
      token: anyNamed('token'),
      projection: anyNamed('projection'),
      client: anyNamed('client'),
    )).thenAnswer((_) async => LinkedInUserModel());
  }

  void withConfiguration() {
    when(configuration.clientSecret).thenAnswer((_) => 'clientSecret');
    when(configuration.projection).thenAnswer((_) => ['projection1']);
    when(configuration.redirectUrl)
        .thenAnswer((_) => 'https://redirectUrl.com');
    when(configuration.frontendRedirectUrl)
        .thenAnswer((_) => 'https://frontendRedirectUrl.com');
    when(configuration.clientId).thenAnswer((_) => 'clientId');
    when(configuration.state).thenAnswer((_) => 'state');
    when(configuration.initialUrl).thenAnswer((_) => 'initialUrl');
  }
}
