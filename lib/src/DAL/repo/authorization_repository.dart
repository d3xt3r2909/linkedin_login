import 'package:flutter/material.dart';
import 'package:linkedin_login/src/DAL/api/exceptions.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/utils/session.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';
import 'package:logging/logging.dart';

class AuthorizationRepository {
  AuthorizationRepository({@required this.api}) : assert(api != null);

  final Logger log = Logger('AuthorizationRepository');
  final LinkedInApi api;

  Future<AuthorizationCodeResponse> fetchAccessTokenCode({
    @required String redirectedUrl,
    @required String clientSecret,
    @required String clientId,
  }) async {
    log.fine('Fetching access token');

    AuthorizationCodeResponse authorizationCode = _getAuthorizationCode(
      redirectedUrl,
    );

    if (authorizationCode.isCodeValid) {
      final LinkedInTokenObject tokenObject = await api.login(
        redirectUrl: redirectedUrl.split('/?')[0],
        clientId: clientId,
        authCode: authorizationCode.code,
        clientSecret: clientSecret,
      );

      authorizationCode.accessToken = tokenObject;

      return authorizationCode;
    }

    throw AuthCodeException(
      authCode: authorizationCode?.code,
      description: 'Authorization code not existing or it is empty.',
    );
  }

  AuthorizationCodeResponse fetchAuthorizationCode({
    @required String redirectedUrl,
  }) {
    return _getAuthorizationCode(redirectedUrl);
  }

  /// Method will parse redirection URL to get authorization code from
  /// query parameters. If there is an error property inside
  /// [AuthorizationCodeResponse] object will be populate
  AuthorizationCodeResponse _getAuthorizationCode(String url) {
    AuthorizationCodeResponse response;
    final List<String> parseUrl = url.split('?');

    if (parseUrl.isNotEmpty) {
      final List<String> queryPart = parseUrl.last.split('&');

      if (queryPart.isNotEmpty && queryPart.first.startsWith('code')) {
        final List<String> codePart = queryPart.first.split('=');
        final List<String> statePart = queryPart.last.split('=');

        // @todo move Session.clientState
        if (statePart[1] == Session.clientState) {
          response = AuthorizationCodeResponse(
            code: codePart[1],
            state: statePart[1],
          );
        } else {
          throw AuthCodeException(
            authCode: statePart[1],
            description:
                'Current auth code is different from initial one: ${Session.clientState}',
          );
        }
      } else if (queryPart.isNotEmpty && queryPart.first.startsWith('error')) {
        throw AuthCodeException(
          authCode: queryPart[2].split('=')[1],
          description: queryPart[1].split('=')[1].replaceAll('+', ' '),
        );
      }
    }

    return response;
  }
}
