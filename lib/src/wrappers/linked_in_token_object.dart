import 'package:linkedin_login/src/wrappers/linked_in_error_object.dart';

/// When you get authorization code, you need to exchange to get access token
/// Expires in is time, when your access token will be invalid
class LinkedInTokenObject {
  String accessToken;
  int expiresIn;
  @deprecated
  LinkedInErrorObject error;

  LinkedInTokenObject({
    this.accessToken,
    this.expiresIn,
    this.error,
  });

  /// If there is not error at all, [isSuccess] getter will return a true value
  /// This means, that you should get correct response
  @deprecated
  get isSuccess => error == null || error.description.isEmpty;
}