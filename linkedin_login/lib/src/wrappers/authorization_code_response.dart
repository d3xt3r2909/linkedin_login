import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';

/// This class will store code, state, access token and error if there is it
/// State represents unique set of characters that will be used for security
/// reasons
/// Code that you will exchange for access token later
/// Error property will be filled up if flow catch any of errors
class AuthorizationCodeResponse {
  AuthorizationCodeResponse({
    this.code,
    this.state,
    this.accessToken,
  });

  String? state;
  String? code;
  LinkedInTokenObject? accessToken;
}
