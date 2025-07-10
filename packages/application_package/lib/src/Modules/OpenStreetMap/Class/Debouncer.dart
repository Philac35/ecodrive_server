import 'dart:async';
import 'dart:ui';



/*
 * Class Debouncer
 * Used to avoid to much reload of Infotraffic in FutureBuilder. It induces a delay before retry.
 */
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }


  void runForText(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}