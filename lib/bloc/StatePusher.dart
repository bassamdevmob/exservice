import 'dart:async';

import 'package:rxdart/rxdart.dart';

class StatePusher<T> {
  final StreamController<T> _controller;

  bool _disposed = false;

  Stream<T> get stream => _controller.stream;

  bool get disposed => _disposed;

  StatePusher.behavior({
    void onListen(),
    void onCancel(),
    bool sync = false,
  }) : _controller = BehaviorSubject<T>(
          onListen: onListen,
          onCancel: onCancel,
          sync: sync,
        );

  StatePusher.publish({
    void onListen(),
    void onCancel(),
    bool sync = false,
  }) : _controller = PublishSubject<T>(
          onListen: onListen,
          onCancel: onCancel,
          sync: sync,
        );

  void push([T data]) {
    if (disposed) return;
    _controller.sink.add(data);
  }

  void pushError(error) {
    if (disposed) return;
    _controller.sink.addError(error);
  }

  void dispose() {
    _disposed = true;
    _controller.close();
  }
}
