import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/DAL/api/exceptions.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

import '../../../utils/shared_mocks.mocks.dart';

void main() {
  late Graph graph;
  LinkedInApi api;
  late AuthorizationRepository repository;

  late _ArrangeBuilder builder;

  setUp(() {
    graph = MockGraph();
    api = MockLinkedInApi();
    repository = AuthorizationRepository(api: api);

    builder = _ArrangeBuilder(
      graph,
      api,
    );
  });

  test('Throw AuthCodeException if state is null', () async {
    expect(
      () async => repository.fetchAccessTokenCode(
        redirectedUrl: 'invalidUrL',
        clientSecret: 'clientSecret',
        clientId: 'clientId',
        clientState: 'clientState',
        client: graph.httpClient,
      ),
      throwsA(isA<AuthCodeException>().having(
        (a) => a.description,
        'Description',
        contains('Cannot parse url: invalidUrL'),
      )),
    );
  });

  test('Throw AuthCodeException if there is server error with state', () async {
    expect(
      () async => repository.fetchAccessTokenCode(
        redirectedUrl:
            'https://www.app.dexter.com/?error=errorDescription&state=aaaa',
        clientSecret: 'clientSecret',
        clientId: 'clientId',
        clientState: 'clientState',
        client: graph.httpClient,
      ),
      throwsA(
        isA<AuthCodeException>()
            .having(
              (a) => a.description,
              'Description',
              contains('errorDescription'),
            )
            .having(
              (a) => a.authCode,
              'authCode',
              contains('aaaa'),
            ),
      ),
    );
  });

  test('Throw AuthCodeException if there is server error without state',
      () async {
    expect(
      () async => repository.fetchAccessTokenCode(
        redirectedUrl: 'https://www.app.dexter.com/?error=errorDescription',
        clientSecret: 'clientSecret',
        clientId: 'clientId',
        clientState: 'clientState',
        client: graph.httpClient,
      ),
      throwsA(isA<AuthCodeException>().having(
        (a) => a.description,
        'Description',
        contains('errorDescription'),
      )),
    );
  });

  test(
      'Throw AuthCodeException when url state code does not match with param one',
      () async {
    expect(
      () async => repository.fetchAccessTokenCode(
        redirectedUrl: 'https://www.app.dexter.com/?code=AAA&state=BBB',
        clientSecret: 'clientSecret',
        clientId: 'clientId',
        clientState: 'CCC',
        client: graph.httpClient,
      ),
      throwsA(
        isA<AuthCodeException>()
            .having(
              (a) => a.description,
              'Description',
              contains('Current auth code is different from initial one: CCC'),
            )
            .having(
              (b) => b.authCode,
              'authCode',
              contains('BBB'),
            ),
      ),
    );
  });

  test('Throw AuthCodeException code does not have value for code or state',
      () async {
    expect(
      () async => repository.fetchAccessTokenCode(
        redirectedUrl: 'https://www.app.dexter.com/?code=&state=',
        clientSecret: 'clientSecret',
        clientId: 'clientId',
        clientState: '',
        client: graph.httpClient,
      ),
      throwsA(
        isA<AuthCodeException>()
            .having(
              (a) => a.description,
              'Description',
              contains('Cannot parse code ('),
            )
            .having(
              (b) => b.authCode,
              'authCode',
              contains('N/A'),
            ),
      ),
    );
  });

  test('Return AuthorizationCodeResponse object for fetchAccessTokenCode',
      () async {
    builder.withApiLogin(graph.httpClient);

    final response = await repository.fetchAccessTokenCode(
      redirectedUrl: 'https://www.app.dexter.com/?code=aaa&state=bbb',
      clientSecret: 'clientSecret',
      clientId: 'clientId',
      clientState: 'bbb',
      client: graph.httpClient,
    );

    expect(response.accessToken!.accessToken, 'accessToken');
    expect(response.accessToken!.expiresIn, 1234);
  });

  test('Return AuthorizationCodeResponse object for fetchAuthorizationCode',
      () async {
    final response = repository.fetchAuthorizationCode(
      redirectedUrl: 'https://www.app.dexter.com/?code=aaa&state=bbb',
      clientState: 'bbb',
    );

    expect(response.state, 'bbb');
    expect(response.code, 'aaa');
  });
}

class _ArrangeBuilder {
  _ArrangeBuilder(
    this.graph,
    this.api, {
    MockClient? client,
  }) : _client = client ?? MockClient() {
    when(graph.api).thenReturn(api);
    when(graph.httpClient).thenReturn(_client);
  }

  final Graph graph;
  final LinkedInApi api;
  final http.Client _client;

  void withApiLogin(http.Client client) {
    when(api.login(
      redirectUrl: 'https://www.app.dexter.com/',
      authCode: 'aaa',
      clientSecret: 'clientSecret',
      clientId: 'clientId',
      client: client,
    )).thenAnswer(
      (_) async => LinkedInTokenObject(
        accessToken: 'accessToken',
        expiresIn: 1234,
      ),
    );
  }
}
