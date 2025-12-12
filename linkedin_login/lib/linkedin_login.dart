/// A Flutter library for LinkedIn OAuth V2 service with OpenID.
///
/// This library helps you implement authorization with LinkedIn OAuth API's.
/// It provides widgets and utilities for authenticating users with LinkedIn
/// and fetching their profile information.
///
/// Example usage:
/// ```dart
/// LinkedInAuthCodeWidget(
///   redirectUrl: 'your-redirect-url',
///   clientId: 'your-client-id',
///   onCallback: (AuthorizationCodeResponse response) {
///     // Handle authorization response
///   },
/// )
/// ```
library linkedin_login;

export 'package:linkedin_login/src/actions.dart';
export 'package:linkedin_login/src/client/linked_in_user_widget.dart';
export 'package:linkedin_login/src/model/linked_in_user_model.dart';
export 'package:linkedin_login/src/server/linked_in_auth_code_widget.dart';
export 'package:linkedin_login/src/utils/scopes.dart';
export 'package:linkedin_login/src/utils/widgets/linked_in_buttons.dart';
export 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
export 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';
