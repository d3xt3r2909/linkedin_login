import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';

/// Response object containing the authorization code and related information
/// from the LinkedIn OAuth flow.
///
/// This class stores the authorization code, state parameter, and access token
/// (if available) returned from the LinkedIn authorization server.
///
/// Example:
/// ```dart
/// AuthorizationCodeResponse response = AuthorizationCodeResponse(
///   code: 'authorization_code_here',
///   state: 'unique_state_string',
/// );
/// ```
class AuthorizationCodeResponse {
  /// Creates an [AuthorizationCodeResponse] with the provided values.
  ///
  /// [code] is the authorization code that can be exchanged for an access
  /// token.
  /// [state] is a unique string used for security purposes to prevent CSRF
  /// attacks.
  /// [accessToken] is the access token if it was provided directly in the
  /// response.
  AuthorizationCodeResponse({
    this.code,
    this.state,
    this.accessToken,
  });

  /// Unique state string used for security purposes to prevent CSRF attacks.
  ///
  /// This should match the state value that was sent in the initial
  /// authorization request.
  String? state;

  /// Authorization code that can be exchanged for an access token.
  ///
  /// This code is used to obtain an access token from the LinkedIn
  /// authorization server.
  String? code;

  /// Access token if it was provided directly in the authorization response.
  ///
  /// In some flows, the access token may be provided directly without
  /// needing to exchange the authorization code.
  LinkedInTokenObject? accessToken;
}
