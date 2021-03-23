import 'package:linkedin_login/src/DAL/api/exceptions.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:http/http.dart' as http;

class AuthorizationRepository {
  AuthorizationRepository({required this.api});

  final LinkedInApi api;

  Future<AuthorizationCodeResponse> fetchAccessTokenCode({
    required String redirectedUrl,
    required String? clientSecret,
    required String? clientId,
    required String clientState,
    required http.Client client,
  }) async {
    log('LinkedInAuth-steps:fetchAccessTokenCode: parsing authorization code... ');
    final authorizationCode = _getAuthorizationCode(
      redirectedUrl,
      clientState,
    );
    log(
      'LinkedInAuth-steps:fetchAccessTokenCode: parsing authorization code... '
      'DONE, isEmpty: ${authorizationCode.code!.isEmpty}'
      ' \n LinkedInAuth-steps:fetchAccessTokenCode: fetching access token...',
    );

    final tokenObject = await api.login(
      redirectUrl: redirectedUrl.split('?')[0],
      clientId: clientId,
      authCode: authorizationCode.code,
      clientSecret: clientSecret,
      client: client,
    );

    log('LinkedInAuth-steps:fetchAccessTokenCode: fetching access token... DONE');

    authorizationCode.accessToken = tokenObject;

    return authorizationCode;
  }

  AuthorizationCodeResponse fetchAuthorizationCode({
    required String redirectedUrl,
    required String clientState,
  }) {
    return _getAuthorizationCode(redirectedUrl, clientState);
  }

  /// Method will parse redirection URL to get authorization code from
  /// query parameters. If there is an error property inside
  /// [AuthorizationCodeResponse] object will be populate
  AuthorizationCodeResponse _getAuthorizationCode(
    String url,
    String clientState,
  ) {
    final List<String> parseUrl = url.split('?');

    if (parseUrl.isNotEmpty) {
      final List<String> queryPart = parseUrl.last.split('&');

      if (queryPart.isNotEmpty && queryPart.first.startsWith('code')) {
        final List<String> codePart = queryPart.first.split('=');
        final List<String> statePart = queryPart.last.split('=');

        if (_isAuthUrlEmpty(codePart, statePart)) {
          throw AuthCodeException(
            authCode: 'N/A',
            description: 'Cannot parse code ($codePart) or state ($statePart)',
          );
        }

        if (statePart[1] == clientState) {
          final test = AuthorizationCodeResponse(
            code: codePart[1],
            state: statePart[1],
          );

          return test;
        } else {
          throw AuthCodeException(
            authCode: statePart[1],
            description:
                'Current auth code is different from initial one: $clientState',
          );
        }
      } else if (queryPart.isNotEmpty && queryPart.first.startsWith('error')) {
        throw AuthCodeException(
          authCode: queryPart.length > 1 ? queryPart[1].split('=')[1] : 'N/A',
          description: queryPart[0].split('=')[1].replaceAll('+', ' '),
        );
      }
    }

    throw AuthCodeException(
      authCode: 'N/A',
      description: 'Cannot parse url: $url',
    );
  }

  bool _isAuthUrlEmpty(List<String> code, List<String> state) {
    return code.length < 2 ||
        state.length < 2 ||
        code[1].isEmpty ||
        state[1].isEmpty;
  }
}
