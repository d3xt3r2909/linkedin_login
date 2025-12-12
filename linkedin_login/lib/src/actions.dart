import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';

/// Action dispatched when user information is successfully fetched.
///
/// This action is emitted when the LinkedIn user profile has been
/// successfully retrieved and includes the user data along with
/// the access token.
@immutable
class UserSucceededAction extends LinkedAction {
  /// Creates a [UserSucceededAction] with the fetched user data.
  const UserSucceededAction(this.user);

  /// The enriched user information including the access token.
  final EnrichedUser user;

  @override
  String toString() {
    return 'UserSucceededAction{user: $user}';
  }
}

/// Action dispatched when fetching user information fails.
///
/// This action is emitted when an error occurs while attempting to
/// fetch the LinkedIn user profile.
@immutable
class UserFailedAction extends ExceptionAction {
  /// Creates a [UserFailedAction] with the error information.
  const UserFailedAction({
    required final Object exception,
    final StackTrace? stackTrace,
  }) : super(exception, stackTrace);

  @override
  String toString() {
    return 'UserFailedAction{exception: $exception}';
  }
}

/// Action dispatched when authorization is successful.
///
/// This action is emitted when the user successfully authorizes the
/// application and an authorization code is received.
@immutable
class AuthorizationSucceededAction extends LinkedAction {
  /// Creates an [AuthorizationSucceededAction] with the authorization response.
  const AuthorizationSucceededAction(this.codeResponse);

  /// The authorization code response containing the code and state.
  final AuthorizationCodeResponse codeResponse;

  @override
  String toString() {
    return 'AuthorizationSucceededAction{codeResponse: $codeResponse}';
  }
}

/// Action dispatched when authorization fails.
///
/// This action is emitted when an error occurs during the authorization
/// process, such as the user denying access or a network error.
@immutable
class AuthorizationFailedAction extends ExceptionAction {
  /// Creates an [AuthorizationFailedAction] with the error information.
  const AuthorizationFailedAction({
    required final Object exception,
    final StackTrace? stackTrace,
  }) : super(exception, stackTrace);

  @override
  String toString() {
    return 'AuthorizationFailedAction{exception: $exception}';
  }
}

/// Base class for actions that represent errors or exceptions.
///
/// This abstract class is used for actions that indicate a failure
/// in the LinkedIn authentication or user fetching process.
@immutable
abstract class ExceptionAction extends LinkedAction {
  /// Creates an [ExceptionAction] with the error information.
  const ExceptionAction(this.exception, [this.stackTrace]);

  /// The exception that occurred.
  final Object exception;

  /// The stack trace associated with the exception, if available.
  final StackTrace? stackTrace;

  @override
  String toString() {
    return '$runtimeType{exception: $exception, stackTrace: $stackTrace}';
  }

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is ExceptionAction && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

/// Base class for all actions in the LinkedIn login flow.
///
/// Actions are used to communicate state changes and events throughout
/// the authentication and user fetching process.
@immutable
abstract class LinkedAction {
  /// Creates a [LinkedAction].
  const LinkedAction();

  @override
  String toString() {
    return '$runtimeType';
  }

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is LinkedAction && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
