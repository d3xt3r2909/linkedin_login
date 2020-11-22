import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void log(
  String message, {
  DateTime time,
  int sequenceNumber,
  int level = 0,
  String name = '',
  Object error,
  Zone zone,
  StackTrace stackTrace,
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
  DateTime time,
  int sequenceNumber,
  int level = 0,
  String name = 'Logger',
  Object error,
  Zone zone,
  StackTrace stackTrace,
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

  var public = false;

  void log(
    String message, {
    DateTime time,
    int sequenceNumber,
    int level = 0,
    String name = 'Logger',
    Object error,
    Zone zone,
    StackTrace stackTrace,
  }) {
    final msg = Colorize('$name: $message ${error ?? ''}');

    if (level == Level.SHOUT.value) {
      msg
        ..white()
        ..bgRed();
    } else if (level == Level.SEVERE.value) {
      msg.lightRed();
    } else if (level == Level.WARNING.value) {
      msg.yellow();
    } else if (level == Level.INFO.value) {
      msg.white();
    } else {
      msg.default_slyle();
    }

    if (public) {
      developer.log(
        message,
        name: name,
        error: error,
        level: level,
        sequenceNumber: sequenceNumber,
        stackTrace: stackTrace,
        time: time,
        zone: zone,
      );

      // ignore: avoid_print
      print(msg.toString());
    } else {
      if (!Debug().isRelease) {
        debugPrint(msg.toString());
      }
    }
  }

  void logError(String message,
      {DateTime time,
      int sequenceNumber,
      String name = 'Logger',
      Object error,
      Zone zone,
      StackTrace stackTrace}) {
    if (public) {
      developer.log(
        message,
        name: name,
        error: error,
        level: Level.SEVERE.value,
        sequenceNumber: sequenceNumber,
        stackTrace: stackTrace,
        time: time,
        zone: zone,
      );
    }
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