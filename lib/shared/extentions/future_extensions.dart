import 'dart:async';

extension FutureExtension<T> on T {
  Future<T> zeroFuture() {
    return Future.delayed(Duration.zero, () {
      return this;
    });
  }

  Future<T> delayedFuture({required int seconds}) {
    return Future.delayed(Duration(seconds: seconds), () {
      return this;
    });
  }
}
