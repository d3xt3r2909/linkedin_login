import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:test/test.dart';

import '../../../utils/mocks.dart';

void main() {
  EpicStore<AppState> store;
  Graph graph;
  LinkedInApi api;
  UserRepository repository;

  _ArrangeBuilder builder;

  setUpAll(() {});

  setUp(() {
    final mockStore = MockStore();
    graph = MockGraph();
    store = EpicStore(mockStore);
    api = MockApi();
    repository = UserRepository(api: api);

    builder = _ArrangeBuilder(
      graph,
      store,
      api,
    );
  });

  test('Throw AuthCodeException if state is null', () async {
    builder
      ..withBasicProfile()
      ..withUserEmail();

    final response = await repository.fetchFullProfile(
      token: LinkedInTokenObject(
        expiresIn: 1234,
        accessToken: 'accessToken',
      ),
      projection: ['projection1'],
      client: graph.httpClient,
    );

    expect(response.email.elements[0].handleDeep.emailAddress,
        'dexter@dexter.com');
    expect(response.token.accessToken, 'accessToken');
    expect(response.firstName.localized.label, 'DexterFirst');
    expect(response.lastName.localized.label, 'DexterLast');
    expect(response.userId, 'id');
  });
}

class _ArrangeBuilder {
  _ArrangeBuilder(
    this.graph,
    this.store,
    this.api,
  ) {
    when(graph.api).thenReturn(api);
  }

  final Graph graph;
  final LinkedInApi api;
  final EpicStore<AppState> store;

  void withBasicProfile() {
    when(api.fetchProfile(
      token: 'accessToken',
      projection: anyNamed('projection'),
      client: anyNamed('client'),
    )).thenAnswer(
      (_) async => _generateUser(),
    );
  }

  void withUserEmail() {
    when(api.fetchEmail(
      token: 'accessToken',
      client: anyNamed('client'),
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
