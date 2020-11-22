import 'package:flutter/widgets.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';

@immutable
class Graph {
  const Graph({
    @required this.authorizationRepository,
    @required this.userRepository,
  })  : assert(authorizationRepository != null),
        assert(userRepository != null);

  final AuthorizationRepository authorizationRepository;
  final UserRepository userRepository;
}
