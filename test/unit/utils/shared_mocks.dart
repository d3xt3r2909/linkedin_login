import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([Graph])
@GenerateMocks([UserRepository])
@GenerateMocks([AuthorizationRepository])
@GenerateMocks([LinkedInApi])
@GenerateMocks([Config])
@GenerateMocks([http.Client])
class SharedMocks {}