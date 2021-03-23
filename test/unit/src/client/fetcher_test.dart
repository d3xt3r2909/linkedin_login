import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/client/fetcher.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

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

  test('Emits UserFailedAction if state code is not valid', () async {
    final exception = Exception('invalid-access-code');
    builder.withAccessCodeError(
      state: 'state',
      client: graph.httpClient,
      clientId: 'clientId',
      redirectUrl: '$urlAfterSuccessfulLogin&state=state',
      secret: 'clientSecret',
      exception: exception,
    );

    expect(
      await ClientFetcher(
        graph: graph,
        url: '$urlAfterSuccessfulLogin&state=state',
      ).fetchUser(),
      isA<UserFailedAction>().having(
        (e) => e.exception,
        'exception',
        exception,
      ),
    );
  });

  test('Emits UserSucceededAction on success', () async {
    final token = LinkedInTokenObject(
      accessToken: 'accessToken',
      expiresIn: 10,
    );
    builder
      ..withAccessCode(
        state: 'state',
        client: graph.httpClient,
        clientId: 'clientId',
        redirectUrl: '$urlAfterSuccessfulLogin&state=state',
        secret: 'clientSecret',
        token: token,
      )
      ..withFullProfile(
        projection: ['projection1'],
        token: token,
        client: graph.httpClient,
      );

    final user = await ClientFetcher(
      graph: graph,
      url: '$urlAfterSuccessfulLogin&state=state',
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
    final token = LinkedInTokenObject(
      accessToken: 'accessToken',
      expiresIn: 10,
    );
    builder
      ..withAccessCode(
        state: 'state',
        client: graph.httpClient,
        clientId: 'clientId',
        redirectUrl: '$urlAfterSuccessfulLogin&state=state',
        secret: 'clientSecret',
        token: token,
      )
      ..withFullProfileError(
        projection: ['projection1'],
        token: token,
        client: graph.httpClient,
        exception: exception,
      );

    expect(
      await ClientFetcher(
        graph: graph,
        url: '$urlAfterSuccessfulLogin&state=state',
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
    this.configuration, {
    MockClient? client,
  })  : api = MockLinkedInApi(),
        _client = client ?? MockClient() {
    when(graph.api).thenReturn(api);
    when(graph.authorizationRepository).thenReturn(authorizationRepository);
    when(graph.linkedInConfiguration).thenReturn(configuration);
    when(graph.userRepository).thenReturn(userRepository);
    when(graph.httpClient).thenReturn(_client);

    withConfiguration();
  }

  final Graph graph;
  final LinkedInApi api;
  final AuthorizationRepository authorizationRepository;
  final UserRepository userRepository;
  final Config configuration;
  final http.Client _client;

  void withAccessCode({
    required String redirectUrl,
    required String secret,
    required String clientId,
    required String state,
    required http.Client client,
    required LinkedInTokenObject token,
  }) {
    when(authorizationRepository.fetchAccessTokenCode(
      redirectedUrl: redirectUrl,
      clientSecret: secret,
      clientId: clientId,
      clientState: state,
      client: client,
    )).thenAnswer(
      (_) async => AuthorizationCodeResponse(
        state: state,
        code: 'code',
        accessToken: token,
      ),
    );
  }

  void withAccessCodeError({
    required String redirectUrl,
    required String secret,
    required String clientId,
    required String state,
    required http.Client client,
    required Exception exception,
  }) {
    when(authorizationRepository.fetchAccessTokenCode(
      redirectedUrl: redirectUrl,
      clientSecret: secret,
      clientId: clientId,
      clientState: state,
      client: client,
    )).thenThrow(exception);
  }

  void withFullProfileError({
    required LinkedInTokenObject token,
    required List<String> projection,
    required http.Client client,
    required Exception exception,
  }) {
    when(userRepository.fetchFullProfile(
      token: token,
      projection: projection,
      client: client,
    )).thenThrow(exception);
  }

  void withFullProfile({
    required LinkedInTokenObject token,
    required List<String> projection,
    required http.Client client,
  }) {
    when(userRepository.fetchFullProfile(
      token: token,
      projection: projection,
      client: client,
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
