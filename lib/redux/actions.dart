import 'package:meta/meta.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LinkedInAction {
  const LinkedInAction();

  @override
  String toString() {
    return '$runtimeType';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkedInAction && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

@immutable
abstract class LinkedInExceptionAction {
  const LinkedInExceptionAction(this.exception);

  final Exception exception;

  @override
  String toString() {
    return '$runtimeType{exception: $exception}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkedInExceptionAction && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
