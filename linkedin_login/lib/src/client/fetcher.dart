import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';

class ClientFetcher {
  ClientFetcher({
    required this.graph,
    required this.url,
  });

  final Graph graph;
  final String url;

  Future<LinkedAction> fetchUser() async {
    try {
      final token = await _fetchAccessTokenUser();
      final user = await _fetchLinkedInProfile(token.accessToken!);

      return UserSucceededAction(
        EnrichedUser(
          user: user,
          token: token.accessToken!,
        ),
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      return UserFailedAction(exception: e, stackTrace: s);
    }
  }

  Future<AuthorizationCodeResponse> _fetchAccessTokenUser() async {
    try {
      log('LinkedInAuth-steps: Fetching access token...');

      final response = await graph.authorizationRepository.fetchAccessTokenCode(
        redirectedUrl: url,
        clientId: graph.linkedInConfiguration.clientId,
        clientSecret: graph.linkedInConfiguration.clientSecret,
        clientState: graph.linkedInConfiguration.state,
        client: graph.httpClient,
      );

      log(
        'LinkedInAuth-steps: Fetching access token... DONE,'
        ' isEmpty: ${response.accessToken?.accessToken?.isEmpty}',
      );

      return response;
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      logError('Unable to fetch access token code', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<LinkedInUser> _fetchLinkedInProfile(
    final LinkedInTokenObject tokenObject,
  ) async {
    try {
      log('LinkedInAuth-steps: Fetching full profile...');

      final user = await graph.userRepository.fetchProfile(
        token: tokenObject,
        client: graph.httpClient,
      );

      log('LinkedInAuth-steps: Fetching full profile... DONE');

      return user;
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      logError('Unable to fetch LinkedIn profile', error: e, stackTrace: s);
      rethrow;
    }
  }
}
