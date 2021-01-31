import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class MockGraph extends Mock implements Graph {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthorizationRepository extends Mock
    implements AuthorizationRepository {}

class MockApi extends Mock implements LinkedInApi {}

class MockConfiguration extends Mock implements Config {}

class MockClient extends Mock implements http.Client {}
