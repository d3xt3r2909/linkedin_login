/// Represents an OAuth access token and its expiration information.
///
/// When you receive an authorization code, you need to exchange it for an
/// access token. This class contains the access token and its expiration time.
///
/// Example:
/// ```dart
/// LinkedInTokenObject token = LinkedInTokenObject(
///   accessToken: 'your_access_token',
///   expiresIn: 3600, // expires in 1 hour
/// );
/// ```
class LinkedInTokenObject {
  /// Creates a [LinkedInTokenObject] with the provided values.
  ///
  /// [accessToken] is the OAuth access token used to authenticate API requests.
  /// [expiresIn] is the number of seconds until the access token expires.
  LinkedInTokenObject({
    this.accessToken,
    this.expiresIn,
  });

  /// The OAuth access token used to authenticate requests to the LinkedIn API.
  ///
  /// This token should be included in the Authorization header of API requests.
  String? accessToken;

  /// The number of seconds until the access token expires.
  ///
  /// After this time, the token will no longer be valid and a new token
  /// must be obtained.
  int? expiresIn;
}
