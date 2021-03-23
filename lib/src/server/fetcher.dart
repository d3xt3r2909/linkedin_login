import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/actions.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/logger.dart';

class ServerFetcher {
  ServerFetcher({
    required this.graph,
    required this.url,
  });

  final Graph? graph;
  final String url;

  Future<LinkedAction> fetchAuthToken() async {
    try {
      log('LinkedInAuth-steps: Fetching authorization code...');

      final authorizationCodeResponse =
          graph!.authorizationRepository.fetchAuthorizationCode(
        redirectedUrl: url,
        clientState: graph!.linkedInConfiguration.state,
      );

      log('LinkedInAuth-steps: Fetching authorization code... DONE, isEmpty: '
          '${authorizationCodeResponse.code?.isEmpty}');

      return AuthorizationSucceededAction(authorizationCodeResponse);
    } on Exception catch (e, s) {
      logError('Unable to fetch auth token', error: e, stackTrace: s);
      return AuthorizationFailedAction(exception: e, stackTrace: s);
    }
  }
}
