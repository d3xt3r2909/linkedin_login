import 'dart:async';

Stream<dynamic> toStream(dynamic action) {
  if (action is Iterable) {
    return Stream.fromIterable(action).asBroadcastStream();
  }
  return Future.value(action).asStream().asBroadcastStream();
}

List<dynamic> toUnsafeList(Stream<dynamic> stream) {
  final events = <dynamic>[];

  stream.listen(events.add);

  // The unsafe part is not closing the stream.
  // Will be closed after the tests finishes.

  return events;
}

Future<void> awaitTerminalValue(Stream<dynamic> stream) {
  final completer = Completer<void>();

  stream
      .timeout(Duration(milliseconds: 10), onTimeout: (it) => it.close())
      .listen(
        (_) => {},
        onError: completer.completeError,
        onDone: completer.complete,
        cancelOnError: true,
      );

  return completer.future;
}
