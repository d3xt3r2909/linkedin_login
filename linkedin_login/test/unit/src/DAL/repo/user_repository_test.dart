import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';

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
    when(graph.api).thenAnswer((final e) => api);

    builder = _ArrangeBuilder(graph, api);
  });

  test('Fetch the user', () async {
    builder.withUserInfoProfile();

    final response = await repository.fetchProfile(
      token: LinkedInTokenObject(
        expiresIn: 1234,
        accessToken: 'accessToken',
      ),
      client: graph.httpClient,
    );

    expect(response.email, 'john.doe@gmail.com');
    expect(response.givenName, 'John');
    expect(response.familyName, 'Doe');
    expect(response.picture, 'picture.png');
    expect(response.sub, 'its_sub');
    expect(response.name, 'John Doe');
  });
}

class _ArrangeBuilder {
  _ArrangeBuilder(
    this.graph,
    this.api, {
    final MockClient? client,
  }) : _client = client ?? MockClient() {
    when(graph.api).thenReturn(api);
    when(graph.httpClient).thenReturn(_client);
  }

  final Graph graph;
  final LinkedInApi api;
  final http.Client _client;

  void withUserInfoProfile() {
    when(
      api.fetchUserInfo(
        token: anyNamed('token'),
        client: _client,
      ),
    ).thenAnswer(
      (final _) async => _generateUser(),
    );
  }

  LinkedInUserModel _generateUser({
    final String firstName = 'John',
    final String familyName = 'Doe',
    final String email = 'john.doe@gmail.com',
    final String picture = 'picture.png',
  }) {
    return LinkedInUserModel(
      familyName: familyName,
      givenName: firstName,
      email: email,
      isEmailVerified: true,
      name: '$firstName $familyName',
      picture: picture,
      locale: null,
      sub: 'its_sub',
    );
  }
}
