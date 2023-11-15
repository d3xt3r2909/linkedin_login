import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/DAL/api/endpoint.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';

import '../../../utils/shared_mocks.mocks.dart';

void main() {
  Graph graph;
  LinkedInApi api;
  MockClient? httpClient;
  late String localHostUrlUserInfo;
  String? localHostUrlLogin;
  late _ArrangeBuilder builder;

  setUpAll(() {
    localHostUrlUserInfo = 'http://localhost:8080/v2/userinfo';
    localHostUrlLogin = 'http://localhost:8080/oauth/v2/accessToken';
  });

  setUp(() {
    graph = MockGraph();
    api = MockLinkedInApi();
    httpClient = MockClient();

    builder = _ArrangeBuilder(
      graph,
      api,
      client: httpClient,
    );
  });

  group('Login user API', () {
    test('with 200 HTTP code', () async {
      final url = '$localHostUrlLogin';
      final Map<String, dynamic> body = {
        'grant_type': 'authorization_code',
        'code': 'code',
        'redirect_uri': 'https://www.app.dexter.com',
        'client_id': 'client_id',
        'client_secret': 'client_secret',
      };
      final responsePath = '${builder.testPath}access_token.json';
      final response = await builder.buildResponse(responsePath, 200);
      await builder.withPostLogin(url, response, body);

      final api = LinkedInApi.test(Endpoint(Environment.vm));

      final linkedInTokenObject = await api.login(
        client: httpClient!,
        redirectUrl: 'https://www.app.dexter.com',
        authCode: 'code',
        clientSecret: 'client_secret',
        clientId: 'client_id',
      );

      expect(linkedInTokenObject, isA<LinkedInTokenObject>());
      expect(linkedInTokenObject.accessToken, 'xxxAccessToken');
      expect(linkedInTokenObject.expiresIn, 5184000);
    });

    test('400 bad request should throw', () async {
      final url = '$localHostUrlLogin';
      final Map<String, dynamic> body = {
        'grant_type': 'authorization_code',
        'code': 'expire',
        'redirect_uri': 'https://www.app.dexter.com',
        'client_id': 'client_id',
        'client_secret': 'client_secret',
      };
      final responsePath = '${builder.testPath}access_token_invalid_code.json';
      final response = await builder.buildResponse(responsePath, 400);
      await builder.withPostLogin(url, response, body);

      final api = LinkedInApi.test(Endpoint(Environment.vm));

      try {
        await api.login(
          client: httpClient!,
          redirectUrl: 'https://www.app.dexter.com',
          authCode: 'expire',
          clientSecret: 'client_secret',
          clientId: 'client_id',
        );
      } on Exception catch (e) {
        expect(e.toString(), contains('Or authorization code expired'));
        expect(e.toString(), contains('"error": "invalid_request"'));
      }
    });
  });

  group('Fetching user info API', () {
    test('with 200 HTTP code', () async {
      final url = localHostUrlUserInfo;
      final responsePath = '${builder.testPath}open_id_user_info.json';
      final response = await builder.buildResponse(responsePath, 200);
      await builder.withFetchUrL(url, response);

      final api = LinkedInApi.test(Endpoint(Environment.vm));

      final linkedInUserModel = await api.fetchUserInfo(
        token: 'accessToken',
        client: httpClient!,
      );

      expect(linkedInUserModel, isA<LinkedInUserModel>());
      expect(linkedInUserModel.familyName, 'Doe');
      expect(linkedInUserModel.givenName, 'John');
      expect(
        linkedInUserModel.picture,
        'https://media-exp1.licdn.com/dms/image/C4D03AQHirapDum_ZbC/profile-displayphoto-shrink_100_100/0?e=1611792000&v=beta&t=ijlJxIZEMFJDUhnJNrsoWX2vCBIUOXWv4eYCTlPOw-c',
      );
      expect(linkedInUserModel.sub, 'clv_xxxxxx');
      expect(linkedInUserModel.email, 'my.email@gmail.com');
      expect(linkedInUserModel.name, 'John Doe');
      expect(linkedInUserModel.locale, isNotNull);
      expect(linkedInUserModel.isEmailVerified, isTrue);
    });

    test('Failed - 401 Unauthorized Invalid access token', () async {
      final url = localHostUrlUserInfo;
      final responsePath = '${builder.testPath}invalid_access_token.json';
      final response = await builder.buildResponse(responsePath, 401);
      await builder.withFetchUrL(url, response);

      try {
        final api = LinkedInApi.test(Endpoint(Environment.vm));
        await api.fetchUserInfo(
          token: 'accessToken',
          client: httpClient!,
        );
      } on Exception catch (e) {
        expect(e.toString(), contains('"message": "Invalid access token"'));
      }
    });
  });

  test('url parser return string', () async {
    final api = LinkedInApi.test(Endpoint(Environment.vm));

    final res = api.takeUrl('https://something.com');

    expect(res, 'https://something.com');
  });

  test('do not split if last is /', () async {
    final api = LinkedInApi.test(Endpoint(Environment.vm));

    final res = api.takeUrl('https://something.com/');

    expect(res, 'https://something.com/');
  });

  test('split if there is question mark, take first', () async {
    final api = LinkedInApi.test(Endpoint(Environment.vm));

    final res = api.takeUrl('https://something.com/?code=bla');

    expect(res, 'https://something.com/');
  });

  test('LinkedInApi factory is called', () async {
    LinkedInApi(Endpoint(Environment.vm));
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

  Future<String> getResponseFileContent(final String pathToFile) async {
    final file = File(pathToFile);
    return file.readAsString();
  }

  Future<void> withFetchUrL(
    final String url,
    final http.Response response,
  ) async {
    final headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer accessToken',
    };

    when(
      _client.get(
        Uri.parse(url),
        headers: headers,
      ),
    ).thenAnswer(
      (final _) async {
        return response;
      },
    );
  }

  Future<void> withPostLogin(
    final String url,
    final http.Response response,
    final Map<String, dynamic> body,
  ) async {
    final headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    when(
      _client.post(
        Uri.parse(url),
        body: body,
        headers: headers,
      ),
    ).thenAnswer(
      (final _) async {
        return response;
      },
    );
  }

  String get testPath =>
      '${Directory.current.path.endsWith('test') ? '.' : './test'}/unit/src/DAL/api/override/';

  Future<http.Response> buildResponse(
    final String responseContentPath,
    final int code,
  ) async {
    final response = await getResponseFileContent(responseContentPath);

    return http.Response(response, code);
  }
}
