import 'dart:async';

class Debouncer {
  final Duration delais;
  Timer? _timer;

  Debouncer({required this.delais});

  void dispose() {
    _timer?.cancel();
  }

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delais, action);
  }
}
