import 'package:linkedin_login/src/DAL/api/endpoint.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/DAL/repo/authorization_repository.dart';
import 'package:linkedin_login/src/DAL/repo/user_repository.dart';
import 'package:linkedin_login/src/utils/configuration.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:http/http.dart' as http;

class Initializer {
  Graph initialise(Config configuration) {
    log('Initializing...');

    final graph = _GraphBuilder().initialise(configuration);

    log('Initializing... Done');

    return graph;
  }
}

class _GraphBuilder {
  Graph initialise(Config configuration) {
    final api = _networking();
    final authRepository = AuthorizationRepository(api: api);
    final userRepository = UserRepository(api: api);

    return Graph(
      authorizationRepository: authRepository,
      userRepository: userRepository,
      api: api,
      linkedInConfiguration: configuration,
      httpClient: http.Client(),
    );
  }

  LinkedInApi _networking() {
    log('Netwoking...');

    final endpoint = Endpoint(Environment.production);

    final api = LinkedInApi(endpoint);

    log('Netwoking... Done');
    return api;
  }
}
