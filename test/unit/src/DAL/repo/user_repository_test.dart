import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../utils/shared_mocks.mocks.dart';

void main() {
  late Graph graph;
  late LinkedInApi api;
  late UserRepository repository;
  late _ArrangeBuilder builder;

  setUpAll(() {});

  setUp(() {
    graph = MockGraph();
    api = MockLinkedInApi();
    repository = UserRepository(api: api);
    when(graph.api).thenAnswer((e) => api);

    builder = _ArrangeBuilder(graph, api);
  });

  test('Throw AuthCodeException if state is null', () async {
    builder
      ..withBasicProfile(
        graph.httpClient,
        ['projection1'],
      )
      ..withUserEmail(graph.httpClient);

    final response = await repository.fetchFullProfile(
      token: LinkedInTokenObject(
        expiresIn: 1234,
        accessToken: 'accessToken',
      ),
      projection: ['projection1'],
      client: graph.httpClient,
    );

    expect(response.email!.elements![0].handleDeep!.emailAddress,
        'dexter@dexter.com');
    expect(response.token.accessToken, 'accessToken');
    expect(response.firstName!.localized!.label, 'DexterFirst');
    expect(response.lastName!.localized!.label, 'DexterLast');
    expect(response.userId, 'id');
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

  void withBasicProfile(http.Client client, List<String> projection) {
    when(api.fetchProfile(
      token: 'accessToken',
      projection: projection,
      client: client,
    )).thenAnswer(
      (_) async => _generateUser(),
    );
  }

  void withUserEmail(http.Client client) {
    when(api.fetchEmail(
      token: 'accessToken',
      client: client,
    )).thenAnswer(
      (_) async => _generateUserEmail(),
    );
  }

  LinkedInUserModel _generateUser({
    String firstName = 'DexterFirst',
    String lastName = 'DexterLast',
  }) {
    return LinkedInUserModel(
      firstName: LinkedInPersonalInfo(
        localized: LinkedInLocalInfo(
          label: firstName,
        ),
        preferredLocal: LinkedInPreferredLocal(country: 'BA', language: 'bs'),
      ),
      lastName: LinkedInPersonalInfo(
        localized: LinkedInLocalInfo(
          label: lastName,
        ),
        preferredLocal: LinkedInPreferredLocal(country: 'BA', language: 'bs'),
      ),
      userId: 'id',
    );
  }

  LinkedInProfileEmail _generateUserEmail({
    String email = 'dexter@dexter.com',
  }) {
    return LinkedInProfileEmail(
      elements: [
        LinkedInDeepEmail(
          handle: 'handle',
          handleDeep: LinkedInDeepEmailHandle(
            emailAddress: email,
          ),
        ),
      ],
    );
  }
}
