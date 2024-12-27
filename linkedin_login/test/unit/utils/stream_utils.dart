import 'dart:async';

Stream<dynamic> toStream(final dynamic action) {
  if (action is Iterable) {
    return Stream.fromIterable(action).asBroadcastStream();
  }
  return Future.value(action).asStream().asBroadcastStream();
}

List<dynamic> toUnsafeList(final Stream<dynamic> stream) {
  final events = <dynamic>[];

  stream.listen(events.add);

  // The unsafe part is not closing the stream.
  // Will be closed after the tests finishes.

  return events;
}

Future<void> awaitTerminalValue(final Stream<dynamic> stream) {
  final completer = Completer<void>();

  stream
      .timeout(
        const Duration(milliseconds: 10),
        onTimeout: (final it) => it.close(),
      )
      .listen(
        (final _) => {},
        onError: completer.completeError,
        onDone: completer.complete,
        cancelOnError: true,
      );

  return completer.future;
}
