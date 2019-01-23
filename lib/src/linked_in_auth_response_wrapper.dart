import 'package:flutter/material.dart';

/// This class will store code, state, access token and error if there is it
/// State represents unique set of characters that will be used for security
/// reasons
/// Code that you will exchange for access token later
/// Error property will be filled up if flow catch any of errors
class AuthorizationCodeResponse {
  String state;
  String code;
  LinkedInTokenObject accessToken;
  LinkedInErrorObject error;

  AuthorizationCodeResponse({
    this.code,
    this.error,
    this.state,
  });
}

/// When you get authorization code, you need to exchange to get access token
/// Expires in is time, when your access token will be invalid
class LinkedInTokenObject {
  String accessToken;
  int expiresIn;
  LinkedInErrorObject error;

  LinkedInTokenObject({
    this.accessToken,
    this.expiresIn,
    this.error,
  });
}

/// This class contains error information
class LinkedInErrorObject {
  String description;
  int statusCode;

  LinkedInErrorObject({
    @required this.description,
    @required this.statusCode,
  });
}
