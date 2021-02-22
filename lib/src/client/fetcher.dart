import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/utils/startup/graph.dart';
import 'package:linkedin_login/src/utils/logger.dart';

class ClientFetcher {
  ClientFetcher(
    this.graph,
    this.url,
  );

  final Graph graph;
  final String url;

  Future<LinkedInUserModel> fetchUser() async {
    try {
      final token = await _fetchAccessTokenUser();
      final user = await _fetchLinkedInProfile(token.accessToken);

      return user;
    } on Exception catch (_) {
      rethrow;
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
    } on Exception catch (e, s) {
      logError('Unable to fetch access token code', error: e, stackTrace: s);
      rethrow;
    }
  }

  Future<LinkedInUserModel> _fetchLinkedInProfile(
    LinkedInTokenObject tokenObject,
  ) async {
    try {
      log('LinkedInAuth-steps: Fetching full profile...');

      final user = await graph.userRepository.fetchFullProfile(
        token: tokenObject,
        projection: graph.linkedInConfiguration.projection,
        client: graph.httpClient,
      );

      log('LinkedInAuth-steps: Fetching full profile... DONE');

      return user;
    } on Exception catch (e, s) {
      logError('Unable to fetch LinkedIn profile', error: e, stackTrace: s);
      rethrow;
    }
  }
}
