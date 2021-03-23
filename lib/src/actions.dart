import 'package:flutter/material.dart';

import '../linkedin_login.dart';

@immutable
class UserSucceededAction extends LinkedAction {
  const UserSucceededAction(this.user);

  final LinkedInUserModel user;

  @override
  String toString() {
    return 'UserSucceededAction{user: $user}';
  }
}

@immutable
class UserFailedAction extends ExceptionAction {
  const UserFailedAction({
    required Object exception,
    StackTrace? stackTrace,
  }) : super(exception, stackTrace);

  @override
  String toString() {
    return 'UserFailedAction{exception: $exception}';
  }
}

@immutable
class AuthorizationSucceededAction extends LinkedAction {
  const AuthorizationSucceededAction(this.codeResponse);

  final AuthorizationCodeResponse codeResponse;

  @override
  String toString() {
    return 'AuthorizationSucceededAction{codeResponse: $codeResponse}';
  }
}

@immutable
class AuthorizationFailedAction extends ExceptionAction {
  const AuthorizationFailedAction({
    required Object exception,
    StackTrace? stackTrace,
  }) : super(exception, stackTrace);

  @override
  String toString() {
    return 'AuthorizationFailedAction{exception: $exception}';
  }
}

@immutable
abstract class ExceptionAction extends LinkedAction {
  const ExceptionAction(this.exception, [this.stackTrace]);

  final Object exception;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return '$runtimeType{exception: $exception, stackTrace: $stackTrace}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExceptionAction && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

@immutable
abstract class LinkedAction {
  const LinkedAction();

  @override
  String toString() {
    return '$runtimeType';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkedAction && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
