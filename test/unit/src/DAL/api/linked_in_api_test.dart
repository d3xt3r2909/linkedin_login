import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/DAL/api/endpoint.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../utils/shared_mocks.mocks.dart';

void main() {
  Graph graph;
  LinkedInApi api;
  MockClient? httpClient;
  String? localHostUrlMeProfile;
  String? localHostUrlLogin;
  late String localHostUrlEmail;
  late _ArrangeBuilder builder;

  setUpAll(() {
    localHostUrlMeProfile = 'http://localhost:8080/v2/me?projection=';
    localHostUrlLogin = 'http://localhost:8080/oauth/v2/accessToken';
    localHostUrlEmail =
        'http://localhost:8080/v2/emailAddress?q=members&projection=(elements*(handle~))';
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

  group('Fetching user profile API', () {
    test('with 200 HTTP code', () async {
      final url =
          '$localHostUrlMeProfile(${ProjectionParameters.projectionWithoutPicture.join(",")})';
      final responsePath = '${builder.testPath}full_user_profile.json';
      final response = await builder.buildResponse(responsePath, 200);
      await builder.withFetchUrL(url, response);

      final api = LinkedInApi.test(Endpoint(Environment.vm));

      final linkedInUserModel = await api.fetchProfile(
        token: 'accessToken',
        projection: ProjectionParameters.projectionWithoutPicture,
        client: httpClient!,
      );

      expect(linkedInUserModel, isA<LinkedInUserModel>());
      expect(linkedInUserModel.localizedLastName, 'Doe');
      expect(linkedInUserModel.localizedFirstName, 'John');
      expect(linkedInUserModel.lastName!.localized!.label, 'Doe');
      expect(linkedInUserModel.firstName!.localized!.label, 'John');
      expect(
        linkedInUserModel.profilePicture!.displayImageContent!.elements![0]
            .identifiers![0].identifier,
        'https://media-exp1.licdn.com/dms/image/C4D03AQHirapDum_ZbC/profile-displayphoto-shrink_100_100/0?e=1611792000&v=beta&t=ijlJxIZEMFJDUhnJNrsoWX2vCBIUOXWv4eYCTlPOw-c',
      );
      expect(linkedInUserModel.userId, 'dwe_Pcc0k3');
      expect(linkedInUserModel.email, isNull);
    });

    test(
        'partially PROJECTION[(id, firstName,lastName,'
        'profilePicture(displayImage~:playableStreams))]', () async {
      final projection = builder.projectionWithoutLocalized();
      final url = '$localHostUrlMeProfile(${projection.join(",")})';
      final responsePath =
          '${builder.testPath}user_profile_no_localized_names.json';
      final response = await builder.buildResponse(responsePath, 200);
      await builder.withFetchUrL(url, response);

      final api = LinkedInApi.test(Endpoint(Environment.vm));
      final linkedInUserModel = await api.fetchProfile(
        token: 'accessToken',
        projection: projection,
        client: httpClient!,
      );

      expect(linkedInUserModel, isA<LinkedInUserModel>());
      expect(linkedInUserModel.localizedLastName, isNull);
      expect(linkedInUserModel.localizedFirstName, isNull);
      expect(linkedInUserModel.lastName!.localized!.label, 'Doe');
      expect(linkedInUserModel.firstName!.localized!.label, 'John');
      expect(
        linkedInUserModel.profilePicture!.displayImageContent!.elements![0]
            .identifiers![0].identifier,
        'https://media-exp1.licdn.com/dms/image/C4D03AQHirapDum_ZbC/profile-displayphoto-shrink_100_100/0?e=1611792000&v=beta&t=ijlJxIZEMFJDUhnJNrsoWX2vCBIUOXWv4eYCTlPOw-c',
      );
      expect(linkedInUserModel.userId, 'dwe_Pcc0k3');
      expect(linkedInUserModel.email, isNull);
    });

    test(
        'partially PROJECTION[((id,localizedFirstName,'
        'localizedLastName,profilePicture(displayImage~:playableStreams))]',
        () async {
      final projection = builder.projectionWithoutNames();
      final url = '$localHostUrlMeProfile(${projection.join(",")})';
      final responsePath = '${builder.testPath}user_profile_no_names.json';
      final response = await builder.buildResponse(responsePath, 200);
      await builder.withFetchUrL(url, response);

      final api = LinkedInApi.test(Endpoint(Environment.vm));
      final linkedInUserModel = await api.fetchProfile(
        token: 'accessToken',
        projection: projection,
        client: httpClient!,
      );

      expect(linkedInUserModel, isA<LinkedInUserModel>());
      expect(linkedInUserModel.localizedLastName, 'Doe');
      expect(linkedInUserModel.localizedFirstName, 'John');
      expect(linkedInUserModel.lastName?.localized?.label, isNull);
      expect(linkedInUserModel.firstName?.localized?.label, isNull);
      expect(
        linkedInUserModel.profilePicture!.displayImageContent!.elements![0]
            .identifiers![0].identifier,
        'https://media-exp1.licdn.com/dms/image/C4D03AQHirapDum_ZbC/profile-displayphoto-shrink_100_100/0?e=1611792000&v=beta&t=ijlJxIZEMFJDUhnJNrsoWX2vCBIUOXWv4eYCTlPOw-c',
      );
      expect(linkedInUserModel.userId, 'dwe_Pcc0k3');
      expect(linkedInUserModel.email, isNull);
    });

    test(
        'partially PROJECTION[((id,localizedFirstName,'
        'localizedLastName,profilePicture(displayImage~:playableStreams))]',
        () async {
      final projection = builder.projectionWithoutNames();
      final url = '$localHostUrlMeProfile(${projection.join(",")})';
      final responsePath = '${builder.testPath}user_profile_no_names.json';
      final response = await builder.buildResponse(responsePath, 200);
      await builder.withFetchUrL(url, response);

      final api = LinkedInApi.test(Endpoint(Environment.vm));
      final linkedInUserModel = await api.fetchProfile(
        token: 'accessToken',
        projection: projection,
        client: httpClient!,
      );

      expect(linkedInUserModel, isA<LinkedInUserModel>());
      expect(linkedInUserModel.localizedLastName, 'Doe');
      expect(linkedInUserModel.localizedFirstName, 'John');
      expect(linkedInUserModel.lastName?.localized?.label, isNull);
      expect(linkedInUserModel.firstName?.localized?.label, isNull);
      expect(
        linkedInUserModel.profilePicture!.displayImageContent!.elements![0]
            .identifiers![0].identifier,
        'https://media-exp1.licdn.com/dms/image/C4D03AQHirapDum_ZbC/profile-displayphoto-shrink_100_100/0?e=1611792000&v=beta&t=ijlJxIZEMFJDUhnJNrsoWX2vCBIUOXWv4eYCTlPOw-c',
      );
      expect(linkedInUserModel.userId, 'dwe_Pcc0k3');
      expect(linkedInUserModel.email, isNull);
    });

    test(
        'partially PROJECTION[((id,localizedFirstName,'
        'localizedLastName,firstName,lastName)]', () async {
      final projection = builder.projectionWithoutProfilePicture();
      final url = '$localHostUrlMeProfile(${projection.join(",")})';
      final responsePath = '${builder.testPath}user_profile_no_image.json';
      final response = await builder.buildResponse(responsePath, 200);
      await builder.withFetchUrL(url, response);

      final api = LinkedInApi.test(Endpoint(Environment.vm));
      final linkedInUserModel = await api.fetchProfile(
        token: 'accessToken',
        projection: projection,
        client: httpClient!,
      );

      expect(linkedInUserModel, isA<LinkedInUserModel>());
      expect(linkedInUserModel.localizedLastName, 'Doe');
      expect(linkedInUserModel.localizedFirstName, 'John');
      expect(linkedInUserModel.lastName!.localized!.label, 'Doe');
      expect(linkedInUserModel.firstName!.localized!.label, 'John');
      expect(linkedInUserModel.profilePicture, isNull);
      expect(linkedInUserModel.userId, 'dwe_Pcc0k3');
      expect(linkedInUserModel.email, isNull);
    });

    test(
        'partially PROJECTION[(localizedFirstName,localizedLastName,firstName,lastName,profilePicture(displayImage~:playableStreams))]',
        () async {
      final projection = builder.projectionWithoutId();
      final url = '$localHostUrlMeProfile(${projection.join(",")})';
      final responsePath = '${builder.testPath}user_profile_no_id.json';
      final response = await builder.buildResponse(responsePath, 200);
      await builder.withFetchUrL(url, response);

      final api = LinkedInApi.test(Endpoint(Environment.vm));
      final linkedInUserModel = await api.fetchProfile(
        token: 'accessToken',
        projection: projection,
        client: httpClient!,
      );

      expect(linkedInUserModel, isA<LinkedInUserModel>());
      expect(linkedInUserModel.localizedLastName, 'Doe');
      expect(linkedInUserModel.localizedFirstName, 'John');
      expect(linkedInUserModel.lastName!.localized!.label, 'Doe');
      expect(linkedInUserModel.firstName!.localized!.label, 'John');
      expect(linkedInUserModel.userId, isNull);
      expect(
        linkedInUserModel.profilePicture!.displayImageContent!.elements![0]
            .identifiers![0].identifier,
        'https://media-exp1.licdn.com/dms/image/C4D03AQHirapDum_ZbC/profile-displayphoto-shrink_100_100/0?e=1611792000&v=beta&t=ijlJxIZEMFJDUhnJNrsoWX2vCBIUOXWv4eYCTlPOw-c',
      );
      expect(linkedInUserModel.email, isNull);
    });

    test('Failed - 401 Unauthorized Invalid access token', () async {
      final url =
          '$localHostUrlMeProfile(${ProjectionParameters.projectionWithoutPicture.join(",")})';
      final responsePath = '${builder.testPath}invalid_access_token.json';
      final response = await builder.buildResponse(responsePath, 401);
      await builder.withFetchUrL(url, response);

      try {
        final api = LinkedInApi.test(Endpoint(Environment.vm));
        await api.fetchProfile(
          token: 'accessToken',
          projection: ProjectionParameters.projectionWithoutPicture,
          client: httpClient!,
        );
      } on Exception catch (e) {
        expect(e.toString(), contains('"message": "Invalid access token"'));
      }
    });
  });

  group('Fetching user email API', () {
    test('with 200 HTTP code', () async {
      final responsePath = '${builder.testPath}user_email.json';
      final response = await builder.buildResponse(responsePath, 200);
      await builder.withFetchUrL(localHostUrlEmail, response);

      final api = LinkedInApi.test(Endpoint(Environment.vm));

      final userEmail = await api.fetchEmail(
        token: 'accessToken',
        client: httpClient!,
      );

      expect(userEmail, isA<LinkedInProfileEmail>());
      expect(userEmail.elements![0].handleDeep?.emailAddress, 'xxx@xxx.xxx');
    });

    test('throws exception if token is null', () async {
      final api = LinkedInApi.test(Endpoint(Environment.vm));

      expect(
        () async => api.fetchEmail(
          token: null,
          client: httpClient!,
        ),
        throwsAssertionError,
      );
    });

    test('with 401 HTTP code', () async {
      final responsePath = '${builder.testPath}invalid_access_token.json';
      final response = await builder.buildResponse(responsePath, 401);
      await builder.withFetchUrL(localHostUrlEmail, response);

      final api = LinkedInApi.test(Endpoint(Environment.vm));

      try {
        await api.fetchEmail(
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
    MockClient? client,
  }) : _client = client ?? MockClient() {
    when(graph.api).thenReturn(api);
    when(graph.httpClient).thenReturn(_client);
  }

  final Graph graph;
  final LinkedInApi api;
  final http.Client _client;

  Future<String> getResponseFileContent(String pathToFile) async {
    final file = File(pathToFile);
    return file.readAsString();
  }

  Future<void> withFetchUrL(String url, http.Response response) async {
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
      (_) async {
        return response;
      },
    );
  }

  Future<void> withPostLogin(
    String url,
    http.Response response,
    Map<String, dynamic> body,
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
      (_) async {
        return response;
      },
    );
  }

  List<String> projectionWithoutLocalized() {
    return [
      ProjectionParameters.firstName,
      ProjectionParameters.lastName,
      ProjectionParameters.profilePicture,
      ProjectionParameters.id,
    ];
  }

  List<String> projectionWithoutNames() {
    return [
      ProjectionParameters.localizedFirstName,
      ProjectionParameters.localizedLastName,
      ProjectionParameters.profilePicture,
      ProjectionParameters.id,
    ];
  }

  List<String> projectionWithoutProfilePicture() {
    return [
      ProjectionParameters.firstName,
      ProjectionParameters.lastName,
      ProjectionParameters.localizedFirstName,
      ProjectionParameters.localizedLastName,
      ProjectionParameters.id,
    ];
  }

  List<String> projectionWithoutId() {
    return [
      ProjectionParameters.firstName,
      ProjectionParameters.lastName,
      ProjectionParameters.localizedFirstName,
      ProjectionParameters.localizedLastName,
      ProjectionParameters.profilePicture,
    ];
  }

  String get testPath =>
      '${Directory.current.path.endsWith('test') ? '.' : './test'}/unit/src/DAL/api/override/';

  Future<http.Response> buildResponse(
    String responseContentPath,
    int code,
  ) async {
    final response = await getResponseFileContent(responseContentPath);

    return http.Response(response, code);
  }
}
