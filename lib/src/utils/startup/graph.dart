import 'package:flutter/widgets.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';

@immutable
class Graph {
  const Graph({
    @required this.authorizationRepository,
    @required this.userRepository,
    @required this.api,
  })  : assert(authorizationRepository != null),
        assert(userRepository != null),
        assert(api != null);

  final AuthorizationRepository authorizationRepository;
  final UserRepository userRepository;
  final LinkedInApi api;
}
