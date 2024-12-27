import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

void log(
  final String message, {
  final DateTime? time,
  final int? sequenceNumber,
  final int level = 0,
  final String name = '',
  final Object? error,
  final Zone? zone,
  final StackTrace? stackTrace,
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
  final String message, {
  final DateTime? time,
  final int? sequenceNumber,
  final int level = 0,
  final String name = 'Logger',
  final Object? error,
  final Zone? zone,
  final StackTrace? stackTrace,
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
    final String message, {
    final DateTime? time,
    final int? sequenceNumber,
    final int level = 0,
    final String name = 'Logger',
    final Object? error,
    final Zone? zone,
    final StackTrace? stackTrace,
  }) {
    final msg = '$name: $message ${error ?? ''}';

    if (!Debug().isRelease) {
      debugPrint(msg);
    }
  }

  void logError(
    final String message, {
    final DateTime? time,
    final int? sequenceNumber,
    final String name = 'Logger',
    final Object? error,
    final Zone? zone,
    final StackTrace? stackTrace,
  }) {
    // ignore: avoid_print
    print('LinkedInLogin: $message ${error ?? ''}');
    stderr
      ..writeln('$message ${error ?? ''}')
      ..flush();
  }
}

class Debug {
  // ignore: do_not_use_environment
  bool get isRelease => const bool.fromEnvironment('dart.vm.product');
}
