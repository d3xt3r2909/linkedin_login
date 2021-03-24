import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/server/fetcher.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../utils/shared_mocks.mocks.dart';

void main() {
  late Graph graph;
  late _ArrangeBuilder builder;

  setUp(() {
    graph = MockGraph();
    final authorizationRepository = MockAuthorizationRepository();
    final userRepository = MockUserRepository();
    final configuration = MockConfig();

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
    builder.withAuthCodeError(
      url: '$urlAfterSuccessfulLogin&state=state',
      state: 'state',
      exception: exception,
    );

    expect(
      await ServerFetcher(
        graph: graph,
        url: '$urlAfterSuccessfulLogin&state=state',
      ).fetchAuthToken(),
      isA<AuthorizationFailedAction>().having(
        (e) => e.exception,
        'exception',
        exception,
      ),
    );
  });

  test('Emits AuthorizationSucceededAction on success', () async {
    builder.withAuthCode(
      url: '$urlAfterSuccessfulLogin&state=state',
      state: 'state',
    );

    final user = await ServerFetcher(
      graph: graph,
      url: '$urlAfterSuccessfulLogin&state=state',
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
  ) : api = MockLinkedInApi() {
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

  void withAuthCode({
    required String url,
    required String state,
  }) {
    when(authorizationRepository.fetchAuthorizationCode(
      redirectedUrl: url,
      clientState: state,
    )).thenAnswer(
      (_) => AuthorizationCodeResponse(
        state: 'state',
        code: 'code-d3xt3r',
      ),
    );
  }

  void withAuthCodeError({
    required String url,
    required String state,
    required Exception exception,
  }) {
    when(authorizationRepository.fetchAuthorizationCode(
      redirectedUrl: url,
      clientState: state,
    )).thenThrow(exception);
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
