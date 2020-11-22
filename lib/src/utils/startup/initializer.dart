import 'package:linkedin_login/src/DAL/api/endpoint.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';

class Initializer {
  Graph initialise() {
    log('Initializing...');

    final Graph graph = _GraphBuilder().initialise();

    log('Initializing... Done');

    return graph;
  }
}

class _GraphBuilder {
  Graph initialise() {
    final api = _networking();
    final authRepository = AuthorizationRepository(api: api);
    final userRepository = UserRepository(api: api);

    return Graph(
      authorizationRepository: authRepository,
      userRepository: userRepository,
      api: api,
    );
  }

  LinkedInApi _networking() {
    log('Netwoking...');

    final Endpoint endpoint = _environment();

    final LinkedInApi api = LinkedInApi(endpoint);

    log('Netwoking... Done');
    return api;
  }

  Endpoint _environment() {
    log('Environment...');
    final endpoint = Endpoint(Environment.production);
    log('Environment... Done');
    return endpoint;
  }
}
