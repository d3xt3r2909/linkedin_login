import 'dart:io';

import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:linkedin_login/src/wrappers/linked_in_error_object.dart';

/// Method will parse redirection URL to get authorization code from
/// query parameters. If there is an error property inside
/// [AuthorizationCodeResponse] object will be populate
AuthorizationCodeResponse getAuthorizationCode({
  String redirectUrl,
  String clientState,
}) {
  AuthorizationCodeResponse response;
  final List<String> parseUrl = redirectUrl.split('?');

  if (parseUrl.isNotEmpty) {
    final List<String> queryPart = parseUrl.last.split('&');

    if (queryPart.isNotEmpty && queryPart.first.startsWith('code')) {
      final List<String> codePart = queryPart.first.split('=');
      final List<String> statePart = queryPart.last.split('=');

      if (statePart[1] == clientState) {
        response = AuthorizationCodeResponse(
          code: codePart[1],
          state: statePart[1],
        );
      } else {
        AuthorizationCodeResponse(
          error: LinkedInErrorObject(
            statusCode: HttpStatus.unauthorized,
            description: 'State code is not valid: ${statePart[1]}',
          ),
          state: statePart[1],
        );
      }
    } else if (queryPart.isNotEmpty && queryPart.first.startsWith('error')) {
      response = AuthorizationCodeResponse(
        error: LinkedInErrorObject(
          statusCode: HttpStatus.unauthorized,
          description: queryPart[1].split('=')[1].replaceAll('+', ' '),
        ),
        state: queryPart[2].split('=')[1],
      );
    }
  }

  return response;
}
