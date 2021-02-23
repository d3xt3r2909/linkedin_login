import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/server/fetcher.dart';
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
      graph,
      authorizationRepository,
      userRepository,
      configuration,
    );
  });

  const urlAfterSuccessfulLogin =
      'https://www.app.dexter.com/?code=AQQTwafddqnG27k6XUWiK0ONMAXKXPietjbeNtDeQGZnBVVM8vHlyrWFHysjGVCFfCAtNw0ajFCitY8fGMm53e7Had8ug0MO62quDLefdSZwNgOFzs6B5jdXgqUg_zad998th7ug4nAzXB71kD4EsYmqjhpUuCDjRNxu3FmRlGzMVOVHQhmEQwjitt0pBA';

  test('Emits AuthorizationFailedAction if state code is not valid', () async {
    final exception = Exception('error-auth-token');
    builder.withAuthCodeError(exception);

    expect(
      await ServerFetcher(
        graph,
        '$urlAfterSuccessfulLogin&state=state',
      ).fetchAuthToken(),
      isA<AuthorizationFailedAction>().having(
        (e) => e.exception,
        'exception',
        exception,
      ),
    );
  });

  test('Emits AuthorizationSucceededAction on success', () async {
    builder.withAuthCode();

    final user = await ServerFetcher(
      graph,
      '$urlAfterSuccessfulLogin&state=state',
    ).fetchAuthToken();

    expect(
      user,
      isA<AuthorizationSucceededAction>().having(
        (u) => u.codeResponse.code,
        'code',
        'code-d3xt3r',
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
    when(graph.userRepository).thenReturn(userRepository);
    when(graph.linkedInConfiguration).thenReturn(configuration);

    withConfiguration();
  }

  final Graph graph;
  final LinkedInApi api;
  final AuthorizationRepository authorizationRepository;
  final UserRepository userRepository;
  final Config configuration;

  void withAuthCode() {
    when(authorizationRepository.fetchAuthorizationCode(
      redirectedUrl: anyNamed('redirectedUrl'),
      clientState: anyNamed('clientState'),
    )).thenAnswer(
      (_) => AuthorizationCodeResponse(
        state: 'state',
        code: 'code-d3xt3r',
      ),
    );
  }

  void withAuthCodeError([Exception exception]) {
    when(authorizationRepository.fetchAuthorizationCode(
      redirectedUrl: anyNamed('redirectedUrl'),
      clientState: anyNamed('clientState'),
    )).thenThrow(exception ?? Exception());
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
