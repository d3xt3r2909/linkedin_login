import 'package:linkedin_login/redux/app_state.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';

class MockStore extends Mock implements Store<AppState> {}

// ignore: must_be_immutable
class MockGraph extends Mock implements Graph {}

class MockUserRepository extends Mock implements UserRepository {}

class MockAuthorizationRepository extends Mock
    implements AuthorizationRepository {}

class MockApi extends Mock implements LinkedInApi {}

class MockConfiguration extends Mock implements Config {}
