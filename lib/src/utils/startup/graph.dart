import 'package:flutter/widgets.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';

@immutable
class Graph {
  const Graph({
    @required this.authorizationRepository,
    // @required this.linkedInUserRepository,
  }) : assert(authorizationRepository != null);

  // assert(linkedInUserRepository != null)

  final AuthorizationRepository authorizationRepository;
// final LinkedInUserRepository linkedInUserRepository;
}
