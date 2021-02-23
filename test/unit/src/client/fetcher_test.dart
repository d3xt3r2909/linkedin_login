import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/client/fetcher.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../utils/mocks.dart';

void main() {
  Graph graph;
  _ArrangeBuilder builder;

  setUp(() {
    graph = MockGraph();
    final authorizationRepository = MockAuthorizationRepository();
    final userRepository = MockUserRepository();
    final configuration = MockConfiguration();

    builder = _ArrangeBuilder(
        graph, authorizationRepository, userRepository, configuration);
  });

  const urlAfterSuccessfulLogin =
      'https://www.app.dexter.com/?code=AQQTwafddqnG27k6XUWiK0ONMAXKXPietjbeNtDeQGZnBVVM8vHlyrWFHysjGVCFfCAtNw0ajFCitY8fGMm53e7Had8ug0MO62quDLefdSZwNgOFzs6B5jdXgqUg_zad998th7ug4nAzXB71kD4EsYmqjhpUuCDjRNxu3FmRlGzMVOVHQhmEQwjitt0pBA';

  test('Emits UserFailedAction if state code is not valid', () async {
    final exception = Exception('invalid-access-code');
    builder.withAccessCodeError(exception);

    expect(
      await ClientFetcher(
        graph,
        '$urlAfterSuccessfulLogin&state=state',
      ).fetchUser(),
      isA<UserFailedAction>().having(
        (e) => e.exception,
        'exception',
        exception,
      ),
    );
  });

  test('Emits UserSucceededAction on success', () async {
    builder
      ..withAccessCode()
      ..withFullProfile();

    final user = await ClientFetcher(
      graph,
      '$urlAfterSuccessfulLogin&state=state',
    ).fetchUser();

    expect(
      user,
      isA<UserSucceededAction>().having(
        (u) => u.user.userId,
        'userId',
        'id_d3xt3r',
      ),
    );
  });

  test(
      'Emits FetchLinkedInUserFailedAction if fetchFullProfile throws exception',
      () async {
    final exception = Exception('invalid-full-profile');
    builder
      ..withAccessCode()
      ..withFullProfileError(exception);

    expect(
      await ClientFetcher(
        graph,
        '$urlAfterSuccessfulLogin&state=state',
      ).fetchUser(),
      isA<UserFailedAction>().having(
        (e) => e.exception,
        'exception',
        exception,
      ),
    );
  });
}

class _ArrangeBuilder {
  _ArrangeBuilder(
    this.graph,
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
    )).thenAnswer(
      (_) async => LinkedInUserModel(
        userId: 'id_d3xt3r',
      ),
    );
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
