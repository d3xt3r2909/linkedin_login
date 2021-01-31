import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

void log(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  String name = '',
  Object? error,
  Zone? zone,
  StackTrace? stackTrace,
}) =>
    SecretLogger().log(
      message,
      name: name,
      error: error,
      level: level,
      sequenceNumber: sequenceNumber,
      stackTrace: stackTrace,
      time: time,
      zone: zone,
    );

void logError(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  String name = 'Logger',
  Object? error,
  Zone? zone,
  StackTrace? stackTrace,
}) =>
    SecretLogger().logError(
      message,
      name: name,
      error: error,
      sequenceNumber: sequenceNumber,
      stackTrace: stackTrace,
      time: time,
      zone: zone,
    );

class SecretLogger {
  factory SecretLogger() => _instance;

  SecretLogger._();

  static final SecretLogger _instance = SecretLogger._();

  void log(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = 'Logger',
    Object? error,
    Zone? zone,
    StackTrace? stackTrace,
  }) {
    final msg = '$name: $message ${error ?? ''}';

    if (!Debug().isRelease) {
      debugPrint(msg);
    }
  }

  void logError(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    String name = 'Logger',
    Object? error,
    Zone? zone,
    StackTrace? stackTrace,
  }) {
    // ignore: avoid_print
    print('LinkedInLogin: $message ${error ?? ''}');
    stderr
      ..writeln('$message ${error ?? ''}')
      ..flush();
  }
}

class Debug {
  bool get isRelease => bool.fromEnvironment('dart.vm.product');
}
