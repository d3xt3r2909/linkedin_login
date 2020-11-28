import 'dart:io';

import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/api/endpoint.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import '../../../utils/mocks.dart';

void main() {
  EpicStore<AppState> store;
  Graph graph;
  LinkedInApi api;
  http.Client httpClient;

  _ArrangeBuilder builder;

  setUpAll(() {});

  setUp(() {
    final mockStore = MockStore();
    graph = MockGraph();
    store = EpicStore(mockStore);
    api = MockApi();
    httpClient = MockClient();

    builder = _ArrangeBuilder(
      graph,
      store,
      api,
      client: httpClient,
    );
  });

  test('Fetch user profile with 200 HTTP code', () async {
    final url =
        'http://localhost:8080/v2/me?projection=(${ProjectionParameters.fullProjection.join(",")})';

    final responsePath =
        'test/unit/src/DAL/api/override/full_user_profile.json';
    await builder.withFetchUrL(url, responsePath);

    final api = LinkedInApi.test(Endpoint(Environment.vm));
    final linkedInUserModel = await api.fetchProfile(
      token: 'accessToken',
      projection: ProjectionParameters.fullProjection,
      client: httpClient,
    );

    expect(linkedInUserModel, isA<LinkedInUserModel>());
  });
}

class _ArrangeBuilder {
  _ArrangeBuilder(
    this.graph,
    this.store,
    this.api, {
    MockClient client,
  }) : _client = client ?? MockClient() {
    when(graph.api).thenReturn(api);
    when(graph.httpClient).thenReturn(_client);
  }

  final Graph graph;
  final LinkedInApi api;
  final http.Client _client;
  final EpicStore<AppState> store;

  Future<String> getResponseFileContent(String pathToFile) async {
    final file = File(pathToFile);
    return file.readAsString();
  }

  Future<void> withFetchUrL(String url, String responseContentPath) async {
    var headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer accessToken',
    };

    final response = await getResponseFileContent(responseContentPath);

    when(
      _client.get(
        Uri.parse(url),
        headers: headers,
      ),
    ).thenAnswer(
      (_) async {
        return http.Response(response, 200);
      },
    );
  }
}
