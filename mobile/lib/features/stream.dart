import 'dart:async';

resume(StreamSubscription? stream) {
  if (stream?.isPaused ?? false) {
    stream?.resume();
  }
}

pause(StreamSubscription? stream) {
  if (!(stream?.isPaused ?? true)) {
    stream?.pause();
  }
}
